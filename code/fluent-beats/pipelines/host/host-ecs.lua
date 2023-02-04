-- Translates Host Metrics to Elastic ECS Event

MODULE_NAME = 'host'
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
  -- required for ML features
  output['event']['dataset'] = MODULE_NAME .. '.' .. event
end

function add_metric_set(input, output, name)
  output['metricset'] = {}
  output['metricset']['name'] = name
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

  -- todo: cores
  output['system']['cpu']['cores'] = 8

  -- system
  output['system']['cpu']['system'] = {}
  output['system']['cpu']['system']['pct'] = input['system_p']

  -- user
  output['system']['cpu']['user'] = {}
  output['system']['cpu']['user']['pct'] = input['user_p']

  add_common(input, output, 'cpu')
end

function memory_to_ecs(input, output)
  -- ECS fields
  output['system'] = {}
  output['system']['memory'] = {}

  -- actual used
  output['system']['memory']['actual'] = {}
  output['system']['memory']['actual']['used'] = {}
  output['system']['memory']['actual']['used']['bytes'] = input['mem.used'] * 1024
  output['system']['memory']['actual']['used']['pct'] = (input['mem.used'] / input['mem.total']) * 100.0
  output['system']['memory']['actual']['free'] = input['mem.free'] * 1024

  add_common(input, output, 'memory')
end

function netif_to_ecs(input, output)
  -- ECS fields
  output['system'] = {}
  output['system']['network'] = {}

  -- in bytes
  output['system']['network']['in'] = {}
  output['system']['network']['in']['bytes'] = input['eth0.rx.bytes']

  -- out bytes
  output['system']['network']['out'] = {}
  output['system']['network']['out']['bytes'] = input['eth0.tx.bytes']

  add_common(input, output, 'network')
end

function load_to_ecs(input, output)
  -- ECS fields
  output['system'] = {}
  output['system']['load'] = {}

  -- load averages
  output['system']['load']['1'] = input['load.1']
  output['system']['load']['5'] = input['load.5']
  output['system']['load']['15'] = input['load.15']

  add_common(input, output, 'load')
end

function host_metric_to_ecs(tag, timestamp, record)
  new_record = {}

  -- Just the basic https://www.elastic.co/guide/en/observability/current/host-metrics.html
  if tag == 'host_cpu' then
    cpu_to_ecs(record, new_record)
  elseif tag == 'host_memory' then
    memory_to_ecs(record, new_record)
  elseif tag == 'host_netif' then
    netif_to_ecs(record, new_record)
  elseif tag == 'host_load' then
    load_to_ecs(record, new_record)
  end
  return 2, timestamp, new_record
end