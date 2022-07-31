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
  output['docker']['cpu'] = {}
  output['docker']['cpu']['stats'] = input['cpu_stats']

  if input['cpu_stats'] then
    output['docker']['cpu']['usage'] = input['cpu_stats']['system_cpu_usage']
  end

  add_common(input, output, 'cpu')

  return output
end

function memory_stats(input)
  output = {}

  output['docker'] = {}
  output['docker']['memory'] = {}
  output['docker']['memory']['stats'] = input['memory_stats']

  -- https://www.datadoghq.com/blog/how-to-collect-docker-metrics/
  if input['memory_stats'] then
    output['docker']['memory']['usage'] = input['memory_stats']['usage']
  end

  add_common(input, output, 'memory')

  return output
end

function disk_stats(input)
  output = {}

  output['docker'] = {}
  output['docker']['disk'] = {}
  output['docker']['disk']['stats'] = input['blkio_stats']

  -- https://www.datadoghq.com/blog/how-to-collect-docker-metrics/
  output['docker']['disk']['read'] = {}
  output['docker']['disk']['write'] = {}
  output['docker']['disk']['read']['bytes'] = 0
  output['docker']['disk']['write']['bytes'] = 0
  if input['blkio_stats']['io_service_bytes_recursive'] then
    for i,att in ipairs(input['blkio_stats']['io_service_bytes_recursive']) do
      if att.op == 'Read' then
        output['docker']['disk']['read']['bytes'] = att.value
      end
      if att.op == 'Write' then
        output['docker']['disk']['write']['bytes'] = att.value
      end
    end
  end

  add_common(input, output, 'disk')

  return output
end

function network_stats(input)
  output = {}

  output['docker'] = {}
  output['docker']['network'] = {}
  output['docker']['network']['stats'] = input['networks']

  -- https://www.datadoghq.com/blog/how-to-collect-docker-metrics/
  output['docker']['network']['ingress'] = {}
  output['docker']['network']['egress'] = {}
  output['docker']['network']['ingress']['bytes'] = 0
  output['docker']['network']['egress']['bytes'] = 0
  if input['networks'] then
    for k,v in pairs(input['networks']) do
      output['docker']['network']['ingress']['bytes'] = output['docker']['network']['ingress']['bytes'] + input['networks'][k]['rx_bytes']
      output['docker']['network']['egress']['bytes'] = output['docker']['network']['egress']['bytes'] + input['networks'][k]['tx_bytes']
    end
  end

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