-- Translates Fluentd Log to Elastic ECS Event
-- https://www.elastic.co/guide/en/ecs/current/index.html
-- https://www.elastic.co/guide/en/observability/8.0/logs-app-fields.html

MODULE_NAME = 'fluentbit'

function event(record, output)
  output['event'] = {}
  output['event']['kind'] = 'event'
  output['event']['module'] = MODULE_NAME
  output['event']['dataset'] = MODULE_NAME .. '.logs'
end

function labels(record, output)
  output['labels'] = {}
  for k,v in pairs(record) do
    -- Find prefixed "flb_" labels and map
    i = string.find(k, "flb_", 1, true)
    if i then
      nk = string.sub(k, i + string.len("flb_"))
      output['labels'][nk] = v
    end
  end
end

function container(record, output)
  output['container'] = {}
  output['container']['id'] = record['container_id']
  output['container']['name'] = record['container_name']
  output['container']['runtime'] = 'docker'
end

function fluentd_to_ecs(tag, timestamp, record)
  -- Output map
  new_record = {}

  -- ECS fields
  event(record, new_record)
  labels(record, new_record)
  container(record, new_record)

  -- Non-ECS fields
  new_record['source'] = record['source']
  new_record['message'] = record['log']

  return 1, timestamp, new_record
end