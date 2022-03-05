MODULE_NAME = 'fluentbit.logs'

-- Translates Fluentd Log to Elastic ECS Event
-- https://www.elastic.co/guide/en/observability/8.0/logs-app-fields.html
function fluentd_to_ecs(tag, timestamp, record)
  -- Output map
  new_record = {}

  -- ECS fields
  new_record['container'] = {}
  new_record['container']['id'] = record['container_id']
  new_record['container']['name'] = record['container_name']
  new_record['container']['runtime'] = 'docker'
  new_record['event'] = {}
  new_record['event']['dataset'] = MODULE_NAME .. '.' .. record['source']
  new_record['event']['module'] = MODULE_NAME

  -- Non-ECS fields
  new_record['source'] = record['source']
  new_record['message'] = record['log']

  return 1, timestamp, new_record
end