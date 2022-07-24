-- Translates Carbon Metric to Elastic ECS Event
-- https://www.elastic.co/guide/en/observability/8.0/metrics-app-fields.html

MODULE_NAME = 'fluent-beats'
ECS_VERSION = "8.0.0"

function add_ecs(input, output)
  output['ecs'] = {}
  output['ecs']['version'] = ECS_VERSION
end

function add_event(input, output)
  output['event'] = {}
  output['event']['kind'] = 'metric'
  output['event']['module'] = MODULE_NAME
  -- Required for ML features
  output['event']['dataset'] = MODULE_NAME .. '.metric'
end

function add_agent(input, output)
  output['agent'] = {}
  output['agent']['name'] = MODULE_NAME
  output['agent']['version'] = ECS_VERSION
end

function add_service(input, output)
  output['service'] = {}
  output['service']['type'] = 'docker'
  output['service']['address'] = 'unix:///var/run/docker.sock'
end

function add_container(input, output)
  output['container'] = {}
  output['container']['runtime'] = 'docker'
  output['container']['id'] = input['id']
  output['container']['name'] = input['name']

-- high level stats
-- https://www.datadoghq.com/blog/how-to-collect-docker-metrics/
  output['container']['cpu'] = {}
  if not next(input['cpu_stats']) then
    output['container']['cpu']['usage'] = input['cpu_stats']['system_cpu_usage']
  end

  output['container']['memory'] = {}
  if not next(input['memory_stats']) then
    output['container']['memory']['usage'] = input['memory_stats']['usage']
  end

  output['container']['disk'] = {}
  output['container']['disk']['read'] = {}
  output['container']['disk']['write'] = {}
  if input['blkio_stats']['io_service_bytes_recursive'] then
    for i,att in ipairs(input['blkio_stats']['io_service_bytes_recursive']) do
      print(att)
      if att.op == 'Read' then
        output['container']['disk']['read']['bytes'] = att.value
      end
      if att.op == 'Write' then
        output['container']['disk']['write']['bytes'] = att.value
      end
    end
  end

  output['container']['network'] = {}
  output['container']['network']['ingress'] = {}
  output['container']['network']['egress'] = {}
  --output['container']['network']['ingress']['bytes'] = input['networks']['eth0']['rx_bytes']
  --output['container']['network']['egress']['bytes'] = input['networks']['eth0']['tx_bytes']
end

function add_metric_set(input, output)
  output['metricset'] = {}
  output['metricset']['name'] = 'container'
end

function add_docker_stats(input, output)
  output['docker'] = {}
  output['docker']['memory'] = input['memory_stats']
  output['docker']['cpu'] = input['cpu_stats']
  output['docker']['precpu'] = input['precpu_stats']
  output['docker']['storage'] = input['storage_stats']
  output['docker']['blkio'] = input['blkio_stats']
  output['docker']['networks'] = input['networks']
  output['docker']['pids'] = input['pids_stats']
end

function docker_stats_to_ecs(tag, timestamp, record)
  new_record = {}

  -- https://www.elastic.co/guide/en/ecs/current/ecs-field-reference.html
  add_ecs(record, new_record)
  add_event(record, new_record)
  add_agent(record, new_record)
  add_metric_set(record, new_record)
  add_service(record, new_record)
  add_container(record, new_record)

  -- https://www.elastic.co/guide/en/observability/8.2/metrics-app-fields.html
  add_docker_stats(record, new_record)

  return 1, timestamp, new_record
end