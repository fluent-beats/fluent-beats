-- Translates Docker Metrics to Elastic ECS Event

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

function delta_cpu_for(cpus_count, delta, cpu_delta)
  if delta <= 0 or cpu_delta == 0 then
		return 0
  end
	return (cpus_count * delta) / cpu_delta
end

function cpu_usage_percent(input, field, cpus_count, cpu_delta)
	delta = input['cpu_stats']['cpu_usage'][field] - input['precpu_stats']['cpu_usage'][field]

  return delta_cpu_for(cpus_count, delta, cpu_delta)
end

function cpu_sys_percent(input, cpus_count, cpu_delta)
	delta = input['cpu_stats']['system_cpu_usage'] - input['precpu_stats']['system_cpu_usage']

	return delta_cpu_for(cpus_count, delta, cpu_delta)
end

function cpu_stats(input)
  output = {}

  output['docker'] = {}
  output['docker']['cpu'] = {}

  if input['cpu_stats'] then

    -- values for cpu_percent
    online_cpus = input['cpu_stats']['online_cpus']
    cpu_delta = 0
    if input['cpu_stats']['system_cpu_usage'] then
      cpu_delta = input['cpu_stats']['system_cpu_usage'] - input['precpu_stats']['system_cpu_usage']
    end

    -- cpu usage total
    output['docker']['cpu']['total'] = {}
    output['docker']['cpu']['total']['norm'] = {}
    output['docker']['cpu']['total']['ticks'] = input['cpu_stats']['cpu_usage']['total_usage']
    output['docker']['cpu']['total']['pct'] = cpu_usage_percent(input, 'total_usage', online_cpus, cpu_delta)
    output['docker']['cpu']['total']['norm']['pct'] = cpu_usage_percent(input, 'total_usage', 1, cpu_delta)

    -- cpu usage kernel
    output['docker']['cpu']['kernel'] = {}
    output['docker']['cpu']['kernel']['norm'] = {}
    output['docker']['cpu']['kernel']['ticks'] = input['cpu_stats']['cpu_usage']['usage_in_kernelmode']
    output['docker']['cpu']['kernel']['pct'] = cpu_usage_percent(input, 'usage_in_kernelmode', online_cpus, cpu_delta)
    output['docker']['cpu']['kernel']['norm']['pct'] = cpu_usage_percent(input, 'usage_in_kernelmode', 1, cpu_delta)

    -- cpu usage user
    output['docker']['cpu']['user'] = {}
    output['docker']['cpu']['user']['norm'] = {}
    output['docker']['cpu']['user']['ticks'] = input['cpu_stats']['cpu_usage']['usage_in_usermode']
    output['docker']['cpu']['user']['pct'] = cpu_usage_percent(input, 'usage_in_usermode', online_cpus, cpu_delta)
    output['docker']['cpu']['user']['norm']['pct'] = cpu_usage_percent(input, 'usage_in_usermode', 1, cpu_delta)

    -- cpu system
    if input['cpu_stats']['system_cpu_usage'] then
      output['docker']['cpu']['system'] = {}
      output['docker']['cpu']['system']['norm'] = {}
      output['docker']['cpu']['system']['ticks'] = input['cpu_stats']['system_cpu_usage']
      output['docker']['cpu']['system']['pct'] = cpu_sys_percent(input, online_cpus, cpu_delta)
      output['docker']['cpu']['system']['norm']['pct'] = cpu_sys_percent(input, 1, cpu_delta)
    end

    -- extended (https://docs.docker.com/engine/api/v1.41/#tag/Container/operation/ContainerStats)
    output['docker']['cpu']['stats'] = {}
    output['docker']['cpu']['stats']['usage'] = input['cpu_stats']['system_cpu_usage']
    output['docker']['cpu']['stats']['delta'] = input['cpu_stats']['cpu_usage']['total_usage'] - input['precpu_stats']['cpu_usage']['total_usage']
    output['docker']['cpu']['stats']['cpus'] = input['cpu_stats']['online_cpus']

    if input['cpu_stats']['system_cpu_usage'] then
      -- like docker stats command
      output['docker']['cpu']['stats']['system'] = {}
      output['docker']['cpu']['stats']['system']['delta'] = input['cpu_stats']['system_cpu_usage'] - input['precpu_stats']['system_cpu_usage']
      output['docker']['cpu']['stats']['percent_usage'] =  (output['docker']['cpu']['stats']['delta'] / output['docker']['cpu']['stats']['system']['delta'])
                                                           * output['docker']['cpu']['stats']['cpus'] * 100.0
    end
  end

  -- ECS
  output['container'] = {}
  output['container']['cpu'] = {}
  output['container']['cpu']['usage'] = output['docker']['cpu']['total']['norm']['pct']
  add_common(input, output, 'cpu')

  return output
end

function memory_stats(input)
  output = {}

  output['docker'] = {}
  output['docker']['memory'] = {}

  if input['memory_stats'] and input['memory_stats']['usage'] then
    -- limit
    output['docker']['memory']['limit'] = input['memory_stats']['limit']

    -- usage
    output['docker']['memory']['usage'] = {}
    output['docker']['memory']['usage']['max'] = input['memory_stats']['max_usage']
    output['docker']['memory']['usage']['total'] = input['memory_stats']['usage']
    output['docker']['memory']['usage']['pct'] = input['memory_stats']['usage'] / input['memory_stats']['limit']

    -- failcnt
    if input['memory_stats']['failcnt'] then
      output['docker']['memory']['fail'] = {}
      output['docker']['memory']['fail']['count'] = input['memory_stats']['failcnt']
    end

    -- extended (https://docs.docker.com/engine/api/v1.41/#tag/Container/operation/ContainerStats)
    if input['memory_stats']['stats'] then
      output['docker']['memory']['stats'] = input['memory_stats']['stats']

      -- rss
      output['docker']['memory']['rss'] = {}
      output['docker']['memory']['rss']['max'] = input['memory_stats']['stats']['total_rss']
      output['docker']['memory']['rss']['pct'] = input['memory_stats']['stats']['total_rss'] / input['memory_stats']['limit']

      -- like docker stats command
      output['docker']['memory']['stats']['available'] = input['memory_stats']['limit']
      output['docker']['memory']['stats']['used'] = input['memory_stats']['usage'] - input['memory_stats']['stats']['cache']
      output['docker']['memory']['stats']['percent_usage'] = (output['docker']['memory']['stats']['used'] / output['docker']['memory']['stats']['available']) * 100.0
    end

    -- ECS
    output['container'] = {}
    output['container']['memory'] = {}
    output['container']['memory']['usage'] = output['docker']['memory']['usage']['pct']
  end

  add_common(input, output, 'memory')

  return output
end

function disk_stats(input)
  output = {}

  output['docker'] = {}
  output['docker']['disk'] = {}
  output['docker']['disk']['read'] = {}
  output['docker']['disk']['write'] = {}
  output['docker']['disk']['read']['bytes'] = 0
  output['docker']['disk']['write']['bytes'] = 0

  --  https://www.datadoghq.com/blog/how-to-collect-docker-metrics/
  if input['blkio_stats']['io_service_bytes_recursive'] then
    for i,att in ipairs(input['blkio_stats']['io_service_bytes_recursive']) do
      -- read
      if att.op == 'Read' then
        output['docker']['disk']['read']['bytes'] = att.value
      end

      --write
      if att.op == 'Write' then
        output['docker']['disk']['write']['bytes'] = att.value
      end
    end
  end

  -- ECS
  output['container'] = {}
  output['container']['disk'] = {}
  output['container']['disk']['read'] = {}
  output['container']['disk']['write'] = {}
  output['container']['disk']['read']['bytes'] = output['docker']['disk']['read']['bytes']
  output['container']['disk']['write']['bytes'] = output['docker']['disk']['write']['bytes']
  add_common(input, output, 'disk')

  return output
end

function network_stats(input)
  output = {}

  output['docker'] = {}
  output['docker']['network'] = {}
  output['docker']['network']['in'] = {}
  output['docker']['network']['in']['bytes'] = 0
  output['docker']['network']['in']['packets'] = 0
  output['docker']['network']['in']['dropped'] = 0
  output['docker']['network']['in']['errors'] = 0
  output['docker']['network']['out'] = {}
  output['docker']['network']['out']['bytes'] = 0
  output['docker']['network']['out']['packets'] = 0
  output['docker']['network']['out']['dropped'] = 0
  output['docker']['network']['out']['errors'] = 0

  if input['networks'] then
    for k,v in pairs(input['networks']) do
      -- in
      output['docker']['network']['in']['bytes'] = output['docker']['network']['in']['bytes'] + input['networks'][k]['rx_bytes']
      output['docker']['network']['in']['packets'] = output['docker']['network']['in']['packets'] + input['networks'][k]['rx_packets']
      output['docker']['network']['in']['dropped'] = output['docker']['network']['in']['dropped'] + input['networks'][k]['rx_dropped']
      output['docker']['network']['in']['errors'] = output['docker']['network']['in']['errors'] + input['networks'][k]['rx_errors']

      -- out
      output['docker']['network']['out']['bytes'] = output['docker']['network']['out']['bytes'] + input['networks'][k]['tx_bytes']
      output['docker']['network']['out']['packets'] = output['docker']['network']['out']['packets'] + input['networks'][k]['tx_packets']
      output['docker']['network']['out']['dropped'] = output['docker']['network']['out']['dropped'] + input['networks'][k]['tx_dropped']
      output['docker']['network']['out']['errors'] = output['docker']['network']['out']['errors'] + input['networks'][k]['tx_errors']
    end
  end

  -- ECS
  output['container'] = {}
  output['container']['network'] = {}
  output['container']['network']['egress'] = {}
  output['container']['network']['ingress'] = {}
  output['container']['network']['egress']['bytes'] = output['docker']['network']['out']['bytes']
  output['container']['network']['ingress']['bytes'] = output['docker']['network']['in']['bytes']
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