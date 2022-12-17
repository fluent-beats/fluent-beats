-- Translates Docker Info to Elastic ECS Event

MODULE_NAME = 'docker'
ECS_VERSION = "8.0.0"
AGENT_NAME = 'fluent-beats'
AGENT_ID = os.getenv('AGENT_ID')
AGENT_HOST = os.getenv('AGENT_HOST')

function add_ecs(input, output)
  output['ecs'] = {}
  output['ecs']['version'] = ECS_VERSION
end

function add_agent(input, output)
  output['agent'] = {}
  output['agent']['id'] = AGENT_ID
  output['agent']['hostname'] = AGENT_HOST
  output['agent']['name'] = AGENT_HOST .. '.' .. AGENT_NAME
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
  output['metricset']['name'] = name
end

function add_service(input, output)
  output['service'] = {}
  output['service']['type'] = 'docker'
  output['service']['address'] = 'unix:///var/run/docker.sock'
end

function add_container(input, output)
  if output['container'] == nil then
    output['container'] = {}
  end

  output['container']['id'] = input['Id']
  output['container']['name'] = input['Name']
  output['container']['runtime'] = 'docker'
end

function add_common(input, output, info)
  -- https://www.elastic.co/guide/en/ecs/current/ecs-field-reference.html
  add_ecs(input, output)
  add_agent(input, output)
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

  -- labels (not useful and usually full of trash)
  -- if input['Config']['Labels'] then
  --   output['docker']['container']['labels'] = {}
  --   for k,v in pairs(input['Config']['Labels']) do
  --     output['docker']['container']['labels'][k] = v
  --   end
  -- end

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

function docker_info_to_ecs(tag, timestamp, record)
  -- split record in multiple records
  new_records = {}

  table.insert(new_records, container_info(record))
  table.insert(new_records, image_info(record))
  -- check piechart 'agent.id' vs 'container.id'
  table.insert(new_records, health_info(record))

  return 2, timestamp, new_records
end