-- Translates Carbon Metric to Elastic ECS

MODULE_NAME = 'fluentbit'

function add_event(input, output)
  output['event'] = {}
  output['event']['kind'] = 'metric'
  output['event']['module'] = MODULE_NAME
  -- Required for ML features
  output['event']['dataset'] = MODULE_NAME .. '.apm'
end

function add_labels(input, output)
  output['labels'] = {}

  -- Split key=value and map
  for i=1, #input['tags'] do
    pair = input['tags'][i]
    k = string.sub(pair, 1, string.find(pair, "=", 1, true) - 1)
    output['labels'][k] = string.sub(pair, string.len(k) + 2)
  end
end

function add_container(input, output)
  output['container'] = {}
  -- output['container']['id'] = input['container_id']
  -- output['container']['name'] = input['container_name']
  -- output['container']['ip_address'] = ip -4 -o address
  output['container']['runtime'] = 'docker'
end

function add_stats(input, output)
  output['stats'] = input
end

function ecs_event(input, output)
  add_event(input, output)
end

function ecs_base(input, output)
  add_labels(input, output)
end

function ecs_metric(input, output)
  add_container(input, output)
  add_stats(input, output)
end

function carbon_to_ecs(tag, timestamp, record)
  new_record = {}

  -- https://www.elastic.co/guide/en/ecs/current/index.html
  ecs_event(record, new_record)
  ecs_base(record, new_record)

  -- https://www.elastic.co/guide/en/observability/8.2/metrics-app-fields.html
  ecs_metric(record, new_record)

  return 1, timestamp, new_record
end