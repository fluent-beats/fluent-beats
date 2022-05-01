-- Translates Carbon Metric to Elastic ECS Event
-- https://www.elastic.co/guide/en/ecs/current/index.html
-- https://www.elastic.co/guide/en/ecs/8.3/ecs-agent.html

MODULE_NAME = 'fluentbit'

function event(record, output)
  output['event'] = {}
  output['event']['kind'] = 'metric'
  output['event']['module'] = MODULE_NAME
  output['event']['dataset'] = MODULE_NAME .. '.apm'
end

function labels(record, output)
  output['labels'] = {}
  -- Split key=value and map
  for i=1, #record['tags'] do
    pair = record['tags'][i]
    k = string.sub(pair, 1, string.find(pair, "=", 1, true) - 1)
    output['labels'][k] = string.sub(pair, string.len(k) + 2)
  end
end

function agent(record, output)
  output['agent'] = {}
  output['agent']['id'] = 'carbon-apm-1.0'
  output['agent']['name'] = 'carbon'
  output['agent']['type'] = 'apm'
  output['agent']['version'] = '1.0'
end

function service(record, output)
  output['service'] = {}
  output['service']['id'] = 'my-service-1.0'
  output['service']['name'] = 'my-service'
  output['service']['version'] = '1.0'
  output['service']['type'] = 'microservice'
end

function apm_to_ecs(tag, timestamp, record)
  -- Output map
  new_record = {}

  -- ECS fields
  event(record, new_record)
  labels(record, new_record)
  agent(new_record, record)
  service(new_record, record)

  -- Non-ECS fields
  new_record['carbon'] = record

  return 1, timestamp, new_record
end