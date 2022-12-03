-- Translates Carbon Metric to Elastic ECS

MODULE_NAME = 'statsd'
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
  output['event']['kind'] = 'metric'
  output['event']['module'] = MODULE_NAME
  -- Required for ML features
  output['event']['dataset'] = MODULE_NAME .. '.' .. event
end

function add_metric_set(input, output, name)
  output['metricset'] = {}
  output['metricset']['name'] = name
end

function add_service(input, output)
  output['service'] = {}
  output['service']['name'] = output['labels']['service']
end

function add_container(input, output)
  output['container'] = {}
  output['container']['runtime'] = 'docker'
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

function add_statsd(input, output)
  output['statsd'] = input
end

function carbon_to_ecs(tag, timestamp, record)
  new_record = {}

  -- https://www.elastic.co/guide/en/ecs/current/ecs-field-reference.html
  add_ecs(record, new_record)
  add_agent(input, new_record)
  add_event(record, new_record, 'apm')
  add_metric_set(input, new_record, 'apm')
  add_labels(record, new_record)
  add_service(record, new_record)
  add_container(record, new_record)

  -- https://www.elastic.co/guide/en/observability/8.2/metrics-app-fields.html
  add_statsd(record, new_record)

  return 2, timestamp, new_record
end