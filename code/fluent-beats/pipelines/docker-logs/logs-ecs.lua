-- Translates Fluentd Log to Elastic ECS

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
  output['event']['kind'] = 'event'
  output['event']['module'] = MODULE_NAME
  -- Required for ML features
  output['event']['dataset'] = MODULE_NAME .. '.' .. event
end

function add_service(input, output)
  output['service'] = {}
  output['service']['none'] = {}
  output['service']['none']['name'] = input['container_id']
end

function add_container(input, output)
  if output['container'] == nil then
    output['container'] = {}
  end

  output['container']['id'] = input['container_id']
  output['container']['name'] = input['container_name']
  output['container']['runtime'] = 'docker'
end

function add_labels(input, output)
  output['labels'] = {}

  for k,v in pairs(input) do
    -- Find prefixed "flb_" Docker Labels and map
    i = string.find(k, "flb_", 1, true)
    if i then
      nk = string.sub(k, i + string.len("flb_"))
      output['labels'][nk] = v
    end
  end
end

function add_message_log(input, output)
  output['stream'] = input['source']
  output['message'] = input['log']
end

function fluentd_to_ecs(tag, timestamp, record)
  new_record = {}

  -- https://www.elastic.co/guide/en/ecs/current/ecs-field-reference.html
  add_ecs(record, new_record)
  add_agent(input, new_record)
  add_event(record, new_record, 'log')
  add_service(record, new_record)
  add_container(record, new_record)
  add_labels(record, new_record)

  -- https://www.elastic.co/guide/en/observability/8.2/logs-app-fields.html
  add_message_log(record, new_record)

  return 2, timestamp, new_record
end