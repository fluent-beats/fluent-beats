-- Translates Fluentd Log to Elastic ECS

MODULE_NAME = 'docker'
ECS_VERSION = "8.0.0"
AGENT_NAME = 'fluent-beats'
AGENT_ID = os.getenv('AGENT_ID')
AGENT_HOST = os.getenv('AGENT_HOST')
AGENT_IP = os.getenv('AGENT_IP')

function add_ecs(input, output)
  output['ecs'] = {}
  output['ecs']['version'] = ECS_VERSION
end

function add_data_stream(input, output)
  -- https://www.elastic.co/pt/blog/an-introduction-to-the-elastic-data-stream-naming-scheme
  output['data_stream'] = {}
  output['data_stream']['type'] = "logs"
  output['data_stream']['dataset'] = MODULE_NAME .. '.logs'
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
  output['event']['kind'] = 'event'
  output['event']['module'] = MODULE_NAME
  -- Required for ML features
  output['event']['dataset'] = MODULE_NAME .. '.' .. event
end

function add_service(input, output)
  output['service'] = {}
  output['service']['name'] = output['labels']['service'] or input['container_name']
end

function add_container(input, output)
  output['container'] = output['container'] or {}
  output['container']['id'] = input['container_id']
  output['container']['name'] = input['container_name']
  output['container']['runtime'] = 'docker'
end

function add_common(input, output, info)
  -- https://www.elastic.co/guide/en/ecs/current/ecs-field-reference.html
  add_ecs(input, output)
  add_data_stream(input, output)
  add_agent(input, output)
  add_host(input, output)
  add_event(input, output, info)
  add_service(input, output)
  add_container(input, output)
end

function add_log(input, output)
  local ignore = { ['container_id']=true, ['container_name']=true, ['message']=true, ['@timestamp']=true }
  output['labels'] = {}
  output['log'] = {}

  for k,v in pairs(input) do
    local i = string.find(k, "flb_", 1, true)
    if i then
      -- log label
      local nk = string.sub(k, i + string.len("flb_"))
      output['labels'][nk] = v
    elseif not ignore[k] then
      -- log property
      output['log'][k] = v
    end
  end

  -- required root message
  output['message'] = input['message']
end

function fluentd_to_ecs(tag, timestamp, record)
  local new_record = {}

  -- delete "/ namespace" from container`s name, because FluentBeats only access local Docker daemon
  record['container_name'] = string.gsub(record['container_name'], "^/", "")

  -- https://www.elastic.co/guide/en/observability/8.2/logs-app-fields.html
  add_log(record, new_record)

  -- ECS fields
  add_common(record, new_record, 'log')

  return 2, timestamp, new_record
end