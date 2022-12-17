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
  output['container'] = {}
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

function containers_info(input)
  output = {}

  -- Beats fields
  output['docker'] = {}
  output['docker']['info'] = {}
  output['docker']['info']['containers'] = {}
  output['docker']['info']['containers']['total'] = input['Containers']
  output['docker']['info']['containers']['running'] = input['ContainersRunning']
  output['docker']['info']['containers']['paused'] = input['ContainersPaused']
  output['docker']['info']['containers']['stopped'] = input['ContainersStopped']

  -- ECS fields
  add_common(input, output, 'info')
  return output
end

function docker_system_to_ecs(tag, timestamp, record)
  -- split record in multiple records
  new_records = {}

  table.insert(new_records, containers_info(record))

  return 2, timestamp, new_records
end