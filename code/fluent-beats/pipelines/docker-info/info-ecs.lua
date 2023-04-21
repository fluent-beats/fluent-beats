-- Translates Docker Info to Elastic ECS Event

MODULE_NAME = 'docker'
ECS_VERSION = "8.0.0"
AGENT_NAME = 'fluent-beats'
AGENT_ID = os.getenv('AGENT_ID')
AGENT_HOST = os.getenv('AGENT_HOST')
AGENT_IP = os.getenv('AGENT_IP')
COLLECT_LABELS = os.getenv('FLB_COLLECT_CONTAINER_LABELS')

function add_ecs(input, output)
  output['ecs'] = {}
  output['ecs']['version'] = ECS_VERSION
end

function add_data_stream(input, output)
  -- https://www.elastic.co/pt/blog/an-introduction-to-the-elastic-data-stream-naming-scheme
  output['data_stream'] = {}
  output['data_stream']['type'] = "metrics"
  output['data_stream']['dataset'] = MODULE_NAME .. '.info'
  output['data_stream']['namespace'] = "default"
end

function add_agent(input, output)
  output['agent'] = {}
  output['agent']['id'] = AGENT_ID
  output['agent']['hostname'] = AGENT_HOST
  output['agent']['name'] = AGENT_HOST .. '.' .. AGENT_NAME
end

function add_host(input, output)
  output['host'] = {}
  output['host']['name'] = AGENT_HOST
  output['host']['ip'] = AGENT_IP
  -- required for ML features
  output['host']['hostname'] = AGENT_HOST
end

function add_event(input, output, event)
  output['event'] = {}
  output['event']['kind'] = 'metric'
  output['event']['module'] = MODULE_NAME
  -- required for ML features
  output['event']['dataset'] = MODULE_NAME .. '.' .. event
end

function add_metric_set(input, output, name)
  output['metricset'] = {}
  output['metricset']['name'] = MODULE_NAME .. '_' .. name
  output['metricset']['period'] = tonumber(os.getenv('FLB_DOCKER_METRICS_INTERVAL')) * 1000
end

function add_service(input, output)
  output['service'] = {}
  output['service']['type'] = 'docker'
  output['service']['address'] = 'unix:///var/run/docker.sock'
end

function add_container(input, output)
  output['container'] = output['container'] or {}
  output['container']['id'] = input['Id']
  output['container']['name'] = input['Name']
  output['container']['runtime'] = 'docker'
end

function add_common(input, output, info)
  -- https://www.elastic.co/guide/en/ecs/current/ecs-field-reference.html
  add_ecs(input, output)
  add_data_stream(input, output)
  add_agent(input, output)
  add_host(input, output)
  add_event(input, output, info)
  add_metric_set(input, output, info)
  add_service(input, output)
  add_container(input, output)
end

function image_info(input)
  output = {}

  -- basic image infos
  output['container'] = {}
  output['container']['image'] = {}
  output['container']['image']['name'] = input['Config']['Image']

  -- ECS fields
  add_common(input, output, 'image')
  return output
end

function container_info(input)
  output = {}

  -- Beats fields
  output['docker'] = {}
  output['docker']['container'] = {}
  output['docker']['container']['created'] = input['Created']
  output['docker']['container']['command'] = input['Config']['Cmd']
  output['docker']['container']['status'] = input['State']['Status']

  -- ips
  output['docker']['container']['ip_addresses'] = {}
  for k,v in pairs(input['NetworkSettings']['Networks']) do
    table.insert(output['docker']['container']['ip_addresses'], input['NetworkSettings']['Networks'][k]['IPAddress'])
  end

  -- labels (usually not so useful and messy)
  if COLLECT_LABELS == "true" and input['Config']['Labels'] then
  --if input['Config']['Labels'] then
    output['docker']['container']['labels'] = {}
    for k,v in pairs(input['Config']['Labels']) do
      output['docker']['container']['labels'][k] = v
    end
  end

  -- container size
  output['docker']['container']['size'] = {}
  output['docker']['container']['size']['root_fs'] = input['SizeRootFs']
  output['docker']['container']['size']['rw'] = input['SizeRw']

  -- ECS fields
  add_common(input, output, 'container')
  return output
end

function health_info(input)
  output = {}

  -- Beats fields
  output['docker'] = {}
  output['docker']['healthcheck'] = {}
  output['docker']['healthcheck']['event'] =  {}
  output['docker']['healthcheck']['status'] = input['State']['Status']
  output['docker']['healthcheck']['event']['start_date'] = input['State']['StartedAt']
  output['docker']['healthcheck']['event']['end_date'] = input['State']['FinishedAt']
  output['docker']['healthcheck']['event']['exit_code'] = input['State']['ExitCode']

  -- health details
  if input['State']['Health'] then
    lastEvent = #(input['State']['Health']['Log']) - 1
    output['docker']['healthcheck']['event']['output'] = input['State']['Health']['Log'][lastEvent]['Output']
    output['docker']['healthcheck']['event']['exit_code'] = input['State']['Health']['Log'][lastEvent]['ExitCode']
    output['docker']['healthcheck']['failingstreak'] = input['State']['Health']['FailingStreak']
  end

  -- ECS fields
  add_common(input, output, 'healthcheck')
  return output
end

function health_to_heartbeat(input)
  output = {}

  -- basic TCP heartbeat given https://www.elastic.co/guide/en/beats/heartbeat/8.7

  monitor_id = string.sub(input['Id'], 1, 10)
  i, j = string.find(input['Config']['Image'], ":")
  image_name = string.sub(input['Config']['Image'], 0, (i ~= nil and i-1 or nil))

  -- monitor
  output['monitor'] = {}
  output['monitor']['type'] = 'tcp'
  output['monitor']['name'] = image_name .. '-' .. monitor_id
  output['monitor']['id'] = 'auto-tcp-' .. monitor_id
  output['monitor']['status'] = (input['State']['Status'] == 'running' and "up" or "down")
  output['monitor']['ip'] = (input['NetworkSettings']['IPAddress'] == '' and AGENT_IP or input['NetworkSettings']['IPAddress'])
  output['monitor']['timespan'] = {}
  if input['State']['Health'] then
    lastEvent = #(input['State']['Health']['Log']) - 1
    output['monitor']['timespan']['gte'] = input['State']['Health']['Log'][lastEvent]['Start']
    output['monitor']['timespan']['lt'] = input['State']['Health']['Log'][lastEvent]['End']
  end

  -- state
  output['state'] = {}
  output['state']['status'] = output['monitor']['status']
  output['state']['up'] = (output['monitor']['status'] == 'up' and 1 or 0)
  output['state']['down'] = (output['monitor']['status'] ~= 'up' and 1 or 0)
  output['state']['id'] = 'default-' .. monitor_id

  -- summary
  output['summary'] = {}
  output['summary']['up'] = output['state']['up']
  output['summary']['down'] = output['state']['down']

  -- url (uses fake port)
  output['url'] = {}
  output['url']['scheme'] = 'tcp'
  output['url']['domain'] = output['monitor']['ip']
  output['url']['port'] = 80
  output['url']['full'] = 'tcp://' .. output['url']['domain'] .. ':80'

  -- agent
  output['agent'] = {}
  output['agent']['id'] = AGENT_ID
  output['agent']['name'] = AGENT_HOST .. '.' .. AGENT_NAME
  output['agent']['type'] = 'heartbeat'

  -- host
  output['host'] = {}
  output['host']['id'] = input['Id']
  output['host']['hostname'] = input['Config']['Hostname']
  output['host']['containerized'] = true
  output['host']['ip'] = {}
  table.insert(output['host']['ip'], AGENT_IP)

  -- container
  output['container'] = {}
  output['container']['image'] = {}
  output['container']['id'] = input['Id']
  output['container']['name'] = input['Name']
  output['container']['runtime'] = 'docker'
  output['container']['image']['name'] = input['Config']['Image']

  -- ECS
  add_ecs(input, output)

  return output
end

function docker_info_to_ecs(tag, timestamp, record)
  -- split record in multiple records
  new_records = {}

  table.insert(new_records, container_info(record))
  table.insert(new_records, image_info(record))
  table.insert(new_records, health_info(record))
  table.insert(new_records, health_to_heartbeat(record))

  return 2, timestamp, new_records
end