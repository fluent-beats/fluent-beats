-- Translates Carbon Metric to Elastic ECS Event
-- https://www.elastic.co/guide/en/observability/8.0/metrics-app-fields.html

MODULE_NAME = 'fluentbit'

function metrics_to_ecs(tag, timestamp, record)
  -- Output map
  new_record = {}

  -- ECS Fields
  new_record['event'] = {}
  new_record['event']['kind'] = 'metric'
  new_record['event']['module'] = MODULE_NAME
  new_record['event']['dataset'] = MODULE_NAME .. '.metrics'
  new_record['labels'] = {}

  -- Non-ECS fields
  new_record['carbon'] = record

  return 1, timestamp, new_record
end