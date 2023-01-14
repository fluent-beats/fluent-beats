-- Translates Carbon Metric to Elastic ECS

MODULE_NAME = 'apm'
ECS_VERSION = "8.0.0"
AGENT_NAME = 'fluent-beats'
AGENT_ID = os.getenv('AGENT_ID')
AGENT_HOST = os.getenv('AGENT_HOST')
AGENT_IP = os.getenv('AGENT_IP')

function add_ecs(input, output)
  output['ecs'] = {}
  output['ecs']['version'] = ECS_VERSION
end

function add_data_stream(input, output)
  -- https://www.elastic.co/pt/blog/an-introduction-to-the-elastic-data-stream-naming-scheme
  output['data_stream'] = {}
  output['data_stream']['type'] = "metrics"
  output['data_stream']['dataset'] = MODULE_NAME .. '.stats'
  output['data_stream']['namespace'] = "default"
end

function add_agent(input, output)
  output['agent'] = {}
  output['agent']['id'] = AGENT_ID
  output['agent']['hostname'] = AGENT_HOST
  output['agent']['name'] = AGENT_HOST .. '.' .. AGENT_NAME
end

function add_host(input, output)
  output['host'] = {}
  output['host']['name'] = AGENT_HOST
  output['host']['ip'] = AGENT_IP
  -- required for ML features
  output['host']['hostname'] = AGENT_HOST
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
  output['container'] = output['container'] or {}
  output['container']['runtime'] = 'docker'
end

function add_common(input, output, info)
  -- https://www.elastic.co/guide/en/ecs/current/ecs-field-reference.html
  add_ecs(input, output)
  add_data_stream(input, output)
  add_agent(input, output)
  add_host(input, output)
  add_event(input, output, info)
  add_metric_set(input, output, info)
  add_service(input, output)
  add_container(input, output)
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

function add_stats(input, output)
  output['stats'] = {}

  -- raw (for alerts)
  bucket = input['bucket']
  output['stats'][bucket] = input['value']

  -- components (for search / dashboards)
  output['stats']['value'] = input['value']
  output['stats']['namespace'] = input['namespace']
  output['stats']['section'] = input['section']
  output['stats']['target'] = input['target']
  output['stats']['action'] = input['action']
end

function carbon_to_ecs(tag, timestamp, record)
  new_record = {}

  -- https://www.elastic.co/guide/en/observability/8.2/metrics-app-fields.html
  add_stats(record, new_record)
  add_labels(record, new_record)

  -- ECS fields
  add_common(record, new_record, 'stats')

  return 2, timestamp, new_record
end