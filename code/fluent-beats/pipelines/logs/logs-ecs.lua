-- Translates Fluentd Log to Elastic ECS

MODULE_NAME = 'fluent-beats'

function add_event(input, output)
  output['event'] = {}
  output['event']['kind'] = 'event'
  output['event']['module'] = MODULE_NAME
  -- Required for ML features
  output['event']['dataset'] = MODULE_NAME .. '.log'
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

function add_container(input, output)
  output['container'] = {}
  output['container']['id'] = input['container_id']
  output['container']['name'] = input['container_name']
  output['container']['runtime'] = 'docker'
end

function add_message(input, output)
  output['stream'] = input['source']
  output['message'] = input['log']
end

function ecs_event(input, output)
  add_event(input, output)
end

function ecs_base(input, output)
  add_labels(input, output)
  add_message(input, output)
end

function ecs_log(input, output)
  add_container(input, output)
end

function fluentd_to_ecs(tag, timestamp, record)
  new_record = {}

  -- https://www.elastic.co/guide/en/ecs/current/index.html
  ecs_event(record, new_record)
  ecs_base(record, new_record)

  -- https://www.elastic.co/guide/en/observability/8.2/logs-app-fields.html
  ecs_log(record, new_record)

  return 1, timestamp, new_record
end