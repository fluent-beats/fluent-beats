MODULE_NAME = 'fluentbit.metrics'

-- Translates StatsD Metric to Elastic ECS Event
-- https://www.elastic.co/guide/en/observability/8.0/metrics-app-fields.html
function statsd_to_ecs(tag, timestamp, record)
  -- Output map
  new_record = {}

  -- ECS Fields
  new_record['event'] = {}
  new_record['event']['dataset'] = MODULE_NAME .. '.statsd'
  new_record['event']['module'] = MODULE_NAME

  -- Non-ECS fields
  new_record['statsd'] = record

  return 1, timestamp, new_record
end