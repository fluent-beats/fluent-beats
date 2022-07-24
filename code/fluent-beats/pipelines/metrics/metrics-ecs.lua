-- Translates Carbon Metric to Elastic ECS Event
-- https://www.elastic.co/guide/en/observability/8.0/metrics-app-fields.html

MODULE_NAME = 'fluent-beats'

function add_event(input, output)
  output['event'] = {}
  output['event']['kind'] = 'metric'
  output['event']['module'] = MODULE_NAME
  -- Required for ML features
  output['event']['dataset'] = MODULE_NAME .. '.metrics'
end

function add_container(input, output)
  output['container'] = {}
  -- output['container']['id'] = input['container_id']
  -- output['container']['name'] = input['container_name']
  -- output['container']['ip_address'] = ip -4 -o address
  output['container']['runtime'] = 'docker'
end

function add_metrics(input, output)
  output['docker'] = input
end

function ecs_event(input, output)
  add_event(input, output)
end

function ecs_base(input, output)

end

function ecs_metric(input, output)
  add_container(input, output)
  add_metrics(input, output)
end

function metrics_to_ecs(tag, timestamp, record)
  new_record = {}

  -- https://www.elastic.co/guide/en/ecs/current/index.html
  ecs_event(record, new_record)
  ecs_base(record, new_record)

  -- https://www.elastic.co/guide/en/observability/8.2/metrics-app-fields.html
  ecs_metric(record, new_record)

  return 1, timestamp, new_record

end