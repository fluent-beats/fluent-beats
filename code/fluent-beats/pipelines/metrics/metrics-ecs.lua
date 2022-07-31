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

-- https://www.datadoghq.com/blog/how-to-collect-docker-metrics/

-- cpu
  output['container']['cpu'] = {}
  if input['cpu_stats'] then
    output['container']['cpu']['usage'] = input['cpu_stats']['system_cpu_usage']
  end

  -- memory
  output['container']['memory'] = {}
  if input['memory_stats'] then
    output['container']['memory']['usage'] = input['memory_stats']['usage']
  end

  -- disk
  output['container']['disk'] = {}
  output['container']['disk']['read'] = {}
  output['container']['disk']['write'] = {}
  output['container']['disk']['read']['bytes'] = 0
  output['container']['disk']['write']['bytes'] = 0
  if input['blkio_stats']['io_service_bytes_recursive'] then
    for i,att in ipairs(input['blkio_stats']['io_service_bytes_recursive']) do
      if att.op == 'Read' then
        output['container']['disk']['read']['bytes'] = att.value
      end
      if att.op == 'Write' then
        output['container']['disk']['write']['bytes'] = att.value
      end
    end
  end

  -- network
  output['container']['network'] = {}
  output['container']['network']['ingress'] = {}
  output['container']['network']['egress'] = {}
  output['container']['network']['ingress']['bytes'] = 0
  output['container']['network']['egress']['bytes'] = 0
  if input['networks'] then
    for k,v in pairs(input['networks']) do
      print(k)
      output['container']['network']['ingress']['bytes'] = output['container']['network']['ingress']['bytes'] + input['networks'][k]['rx_bytes']
      output['container']['network']['egress']['bytes'] = output['container']['network']['egress']['bytes'] + input['networks'][k]['tx_bytes']
    end
  end
end

function add_metric_set(input, output)
  output['metricset'] = {}
  output['metricset']['name'] = 'container'
end

function add_docker_stats(input, output)
  output['docker'] = {}
  output['docker']['memory'] = input['memory_stats']
  output['docker']['cpu'] = input['cpu_stats']
  output['docker']['storage'] = input['storage_stats']
  output['docker']['disk'] = input['blkio_stats']
  output['docker']['network'] = input['networks']
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