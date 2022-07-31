-- Translates Carbon Metric to Elastic ECS Event
-- https://www.elastic.co/guide/en/observability/8.0/metrics-app-fields.html

MODULE_NAME = 'docker'
ECS_VERSION = "8.0.0"

function add_ecs(input, output)
  output['ecs'] = {}
  output['ecs']['version'] = ECS_VERSION
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
  output['service']['type'] = 'docker'
  output['service']['address'] = 'unix:///var/run/docker.sock'
end

function add_container(input, output)
  output['container'] = {}
  output['container']['id'] = input['id']
  output['container']['name'] = input['name']
  output['container']['runtime'] = 'docker'
end

function add_common(input, output, stat)
  -- https://www.elastic.co/guide/en/ecs/current/ecs-field-reference.html
  add_ecs(input, output)
  add_event(input, output, stat)
  add_metric_set(input, output, stat)
  add_service(input, output)
  add_container(input, output)
end

function cpu_stats(input)
  output = {}

  output['docker'] = {}
  output['docker']['cpu'] = input['cpu_stats']
  add_common(input, output, 'cpu')

  return output
end

function memory_stats(input)
  output = {}

  output['docker'] = {}
  output['docker']['memory'] = input['memory_stats']
  add_common(input, output, 'memory')

  return output
end

function disk_stats(input)
  output = {}

  output['docker'] = {}
  output['docker']['disk'] = input['blkio_stats']
  add_common(input, output, 'disk')

  return output
end

function network_stats(input)
  output = {}

  output['docker'] = {}
  output['docker']['network'] = input['networks']
  add_common(input, output, 'network')

  return output
end

function docker_stats_to_ecs(tag, timestamp, record)
  -- split record in multiple records
  new_records = {}

  table.insert(new_records, cpu_stats(record))
  table.insert(new_records, memory_stats(record))
  table.insert(new_records, disk_stats(record))
  table.insert(new_records, network_stats(record))

  return 2, timestamp, new_records
end