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

function json_to_table(json)
  local data = {}

  for entry in string.gmatch(json, '([^,]+)') do
    for k,v in string.gmatch(entry, '"(%w+)":([^{:}]+)') do
      data[k] = v:gsub("%\"", "")
    end
  end

  return data
end

function uptime_ecs(input, output)
  add_ecs(input, output)

  -- agent
  output['agent'] = output['agent'] or {}
  output['agent']['id'] = AGENT_ID
  output['agent']['name'] = AGENT_HOST .. '.' .. AGENT_NAME
  output['agent']['type'] = 'heartbeat'

  -- container
  output['container'] = output['container'] or {}
  output['container']['image'] = {}
  output['container']['id'] = input['Id']
  output['container']['name'] = input['Name']
  output['container']['runtime'] = 'docker'
  output['container']['image']['name'] = input['Config']['Image']

  -- host
  output['host'] = output['host'] or {}
  output['host']['id'] = input['Id']
  output['host']['hostname'] = input['Config']['Hostname']
  output['host']['ip'] = {}
  table.insert(output['host']['ip'], AGENT_IP)

  -- url (uses fake port)
  output['url'] = output['url'] or {}
  output['url']['scheme'] = output['monitor']['type']
  output['url']['domain'] = output['monitor']['ip']
  output['url']['port'] = output['tcp']['port']
  output['url']['full'] = 'tcp://' .. output['url']['domain'] .. ':' .. output['url']['port']
end

function parse_docker_log_date(log_date)
  -- https://docs.docker.com/engine/reference/commandline/logs/

  local pattern = "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+).(%d+)"
  local xyear, xmonth, xday, xhour, xminute, xseconds, xnanos = log_date:match(pattern)
  local epoch_seconds = os.time({year = xyear, month = xmonth, day = xday, hour = xhour, min = xminute, sec = xseconds})
  local epoch_nanos = epoch_seconds * 1000 * 1000 * 1000

  return math.floor(epoch_nanos + xnanos)
end

function us_between_ns(end_nanos, start_nanos)
  return math.floor(end_nanos / 1000 - start_nanos / 1000)
end

function image_info(input)
  local output = {}

  -- basic image infos
  output['container'] = {}
  output['container']['image'] = {}
  output['container']['image']['name'] = input['Config']['Image']

  -- ECS fields
  add_common(input, output, 'image')

  return output
end

function container_info(input)
  local output = {}

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
  local output = {}

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
    local lastEvent = #(input['State']['Health']['Log']) - 1
    output['docker']['healthcheck']['event']['output'] = input['State']['Health']['Log'][lastEvent]['Output']
    output['docker']['healthcheck']['event']['exit_code'] = input['State']['Health']['Log'][lastEvent]['ExitCode']
    output['docker']['healthcheck']['failingstreak'] = input['State']['Health']['FailingStreak']
  end

  -- ECS fields
  add_common(input, output, 'healthcheck')

  return output
end

function health_to_heartbeat(input)
  local output = {}

  -- Beats fields https://www.elastic.co/guide/en/beats/heartbeat/current
  -- monitor
  output['monitor'] = {}
  output['monitor']['type'] = 'tcp'
  output['monitor']['name'] = input['Name']
  output['monitor']['id'] = 'auto-tcp-' .. input['Name']
  output['monitor']['status'] = (input['State']['Status'] == 'running' and "up" or "down")
  output['monitor']['ip'] = (input['NetworkSettings']['IPAddress'] == '' and AGENT_IP or input['NetworkSettings']['IPAddress'])

  -- monitor duration
  output['monitor']['duration'] = {}
  if input['State']['Health'] then
    local lastEvent = #(input['State']['Health']['Log']) - 1
    local start_at = input['State']['Health']['Log'][lastEvent]['Start']
    local end_at = input['State']['Health']['Log'][lastEvent]['End']
    output['monitor']['duration']['us'] = us_between_ns(parse_docker_log_date(end_at), parse_docker_log_date(start_at))
  else
    output['monitor']['duration']['us'] = 1000
  end

  -- monitor state
  output['state'] = {}
  output['state']['status'] = output['monitor']['status']
  output['state']['up'] = (output['monitor']['status'] == 'up' and 1 or 0)
  output['state']['down'] = (output['monitor']['status'] ~= 'up' and 1 or 0)
  output['state']['id'] = 'default-' .. input['Name']

  -- monitor summary
  output['summary'] = {}
  output['summary']['up'] = output['state']['up']
  output['summary']['down'] = output['state']['down']

  -- observer
  output['observer'] = {}
  output['observer']['name'] = 'geo-' .. input['Name']
  output['observer']['geo'] = {}
  output['observer']['geo']['name'] = geo_fields['query']
  output['observer']['geo']['continent_name'] = geo_fields['continent']
  output['observer']['geo']['country_iso_code'] = geo_fields['countryCode']
  output['observer']['geo']['region_iso_code'] = geo_fields['region']
  output['observer']['geo']['city_name'] = geo_fields['city']
  output['observer']['geo']['timezone'] = geo_fields['timezone']
  output['observer']['geo']['location'] = geo_fields['lon'] .. ',' .. geo_fields['lat']

  -- apm service
  output['name'] = input['Name']

  -- host
  output['host'] = {}
  output['host']['containerized'] = true

  -- tcp
  output['tcp'] = {}
  output['tcp']['port'] = 80

  -- ECS fields
  uptime_ecs(input, output)

  return output
end

function docker_info_to_ecs(tag, timestamp, record)
  local new_records = {}

  -- delete "/ namespace" from container`s name, because FluentBeats only access local Docker daemon
  record['Name'] = string.gsub(record['Name'], "^/", "")

  -- split record in multiple records
  table.insert(new_records, container_info(record))
  table.insert(new_records, image_info(record))
  table.insert(new_records, health_info(record))
  table.insert(new_records, health_to_heartbeat(record))

  return 2, timestamp, new_records
end

-- load geo fields
geo_fields = json_to_table(os.getenv('AGENT_GEO'))