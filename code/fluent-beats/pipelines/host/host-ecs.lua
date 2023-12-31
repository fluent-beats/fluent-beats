-- Translates Host Metrics to Elastic ECS Event

MODULE_NAME = 'host'
ECS_VERSION = "8.0.0"
AGENT_NAME = 'fluent-beats'
AGENT_ID = os.getenv('AGENT_ID')
AGENT_HOST = os.getenv('AGENT_HOST')
AGENT_IP = os.getenv('AGENT_IP')
HOST_NETIF = os.getenv('FLB_HOST_NET_INTERFACE')
HOST_NUM_PROCS = tonumber(os.getenv('HOST_NUM_PROCS'))

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
  output['host'] = output['host'] or {}
  output['host']['name'] = AGENT_HOST
  output['host']['ip'] = AGENT_IP
  -- required for ML features
  output['host']['hostname'] = AGENT_HOST
end

function add_event(input, output, event)
  output['event'] = {}
  output['event']['kind'] = 'metric'
  output['event']['module'] = MODULE_NAME
  -- required for ML features
  output['event']['dataset'] = MODULE_NAME .. '.' .. event
end

function add_metric_set(input, output, name)
  output['metricset'] = {}
  output['metricset']['name'] = MODULE_NAME .. '_' .. name
  output['metricset']['period'] = tonumber(os.getenv('FLB_HOST_METRICS_INTERVAL')) * 1000
end

function add_common(input, output, info)
  -- https://www.elastic.co/guide/en/ecs/current/ecs-field-reference.html
  add_ecs(input, output)
  add_data_stream(input, output)
  add_agent(input, output)
  add_host(input, output)
  add_event(input, output, info)
  add_metric_set(input, output, info)
end

function cpu_to_ecs(input, output)
  -- ECS fields
  output['system'] = {}
  output['system']['cpu'] = {}

  -- cores
  output['system']['cpu']['cores'] = HOST_NUM_PROCS

  -- in_cpu returns normalized values (pct / cores)
  --   adjust input to be scaled percent (1.0 -> 0.0)
  --   for 'pct' undo (scaled / cores)
  --   for 'norm' just use scaled

  -- total
  scaled = input['cpu_p'] * 0.01
  output['system']['cpu']['total'] = {}
  output['system']['cpu']['total']['norm'] = {}
  output['system']['cpu']['total']['pct'] = scaled * HOST_NUM_PROCS
  output['system']['cpu']['total']['norm']['pct'] = scaled

  -- system
  scaled = input['system_p'] * 0.01
  output['system']['cpu']['system'] = {}
  output['system']['cpu']['system']['norm'] = {}
  output['system']['cpu']['system']['pct'] = scaled * HOST_NUM_PROCS
  output['system']['cpu']['system']['norm']['pct'] = scaled

  -- user
  scaled = input['user_p'] * 0.01
  output['system']['cpu']['user'] = {}
  output['system']['cpu']['user']['norm'] = {}
  output['system']['cpu']['user']['pct'] = scaled * HOST_NUM_PROCS
  output['system']['cpu']['user']['norm']['pct'] = scaled

  add_common(input, output, 'cpu')
end

function disk_to_ecs(input, output)
  -- ECS fields
  output['system'] = {}
  output['system']['diskio'] = {}

  -- in_disk returns (sectors * standard UNIX 512-byte sectors size)
  --   input will exact match ECS read/write bytes

  --read
  output['system']['diskio']['read'] = {}
  output['system']['diskio']['read']['bytes'] = input['read_bytes']
  output['system']['diskio']['read']['count'] = input['read_count']
  output['system']['diskio']['read']['time'] = input['read_time']

  --write
  output['system']['diskio']['write'] = {}
  output['system']['diskio']['write']['bytes'] = input['write_bytes']
  output['system']['diskio']['write']['count'] = input['write_count']
  output['system']['diskio']['write']['time'] = input['write_time']

  add_common(input, output, 'disk')
end

function fs_to_ecs(input, output)
  -- ECS fields
  output['system'] = {}
  output['system']['filesystem'] = {}

  output['system']['filesystem']['mount_point'] = input['mount_point']
  output['system']['filesystem']['total'] = input['total']
  output['system']['filesystem']['free'] = input['free']
  output['system']['filesystem']['available'] = input['available']
  output['system']['filesystem']['files'] = input['files']
  output['system']['filesystem']['free_files'] = input['free_files']

  output['system']['filesystem']['used'] = {}
  output['system']['filesystem']['used']['bytes'] = input['total'] - input['available']
  -- scaled percent (1.0 -> 0.0)
  output['system']['filesystem']['used']['pct'] = (input['total'] - input['available']) / input['total']

  add_common(input, output, 'filesystem')
end

function memory_to_ecs(input, output)
  -- ECS fields
  output['system'] = {}
  output['system']['memory'] = {}

  -- memory
  output['system']['memory']['free'] = input['mem.free'] * 1024
  output['system']['memory']['total'] = input['mem.total'] * 1024
  output['system']['memory']['cached'] = input['mem.cached'] * 1024
  output['system']['memory']['used'] = {}
  output['system']['memory']['used']['bytes'] = input['mem.used'] * 1024
  -- scaled percent (1.0 -> 0.0)
  output['system']['memory']['used']['pct'] = input['mem.used'] / input['mem.total']

  -- memory actual
  output['system']['memory']['actual'] = {}
  output['system']['memory']['actual']['free'] = input['mem.available'] * 1024
  output['system']['memory']['actual']['used'] = {}
  output['system']['memory']['actual']['used']['bytes'] = (input['mem.total'] - input['mem.available']) * 1024
   -- scaled percent (1.0 -> 0.0)
  output['system']['memory']['actual']['used']['pct'] = (input['mem.total'] - input['mem.available']) / input['mem.total']

  add_common(input, output, 'memory')
end

function netif_to_ecs(input, output)
  -- ECS fields
  output['system'] = {}
  output['system']['network'] = {}

  -- in bytes
  output['system']['network']['in'] = {}
  output['system']['network']['in']['bytes'] = input[HOST_NETIF .. '.rx.bytes']

  -- out bytes
  output['system']['network']['out'] = {}
  output['system']['network']['out']['bytes'] = input[HOST_NETIF .. '.tx.bytes']

  -- hosts view (new)
  output['host'] = {}
  output['host']['network'] = {}
  output['host']['network']['ingress'] = {}
  output['host']['network']['ingress']['bytes'] = input[HOST_NETIF .. '.rx.bytes']
  output['host']['network']['egress'] = {}
  output['host']['network']['egress']['bytes'] = input[HOST_NETIF .. '.tx.bytes']

  add_common(input, output, 'network')
end

function load_to_ecs(input, output)
  -- ECS fields
  output['system'] = {}
  output['system']['load'] = {}
  output['system']['load']['norm'] = {}

  -- load cores
  output['system']['load']['cores'] = HOST_NUM_PROCS

  -- load averages
  output['system']['load']['1'] = input['load.1']
  output['system']['load']['5'] = input['load.5']
  output['system']['load']['15'] = input['load.15']

  -- load normalized averages
  output['system']['load']['norm']['1'] = input['load.1'] / HOST_NUM_PROCS
  output['system']['load']['norm']['5'] = input['load.5'] / HOST_NUM_PROCS
  output['system']['load']['norm']['15'] = input['load.15'] / HOST_NUM_PROCS

  add_common(input, output, 'load')
end

function host_metric_to_ecs(tag, timestamp, record)
  local new_record = {}

  -- https://www.elastic.co/guide/en/observability/current/host-metrics.html
  if tag == 'host_cpu' then
    cpu_to_ecs(record, new_record)
  elseif tag == 'host_disk' then
    disk_to_ecs(record, new_record)
  elseif tag == 'host_fs' then
    fs_to_ecs(record, new_record)
  elseif tag == 'host_memory' then
    memory_to_ecs(record, new_record)
  elseif tag == 'host_netif' then
    netif_to_ecs(record, new_record)
  elseif tag == 'host_load' then
    load_to_ecs(record, new_record)
  end

  return 2, timestamp, new_record
end