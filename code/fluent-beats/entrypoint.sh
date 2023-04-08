echo "---------------------"
echo "Fluent Beats"

# extract_secrets (test variable to support ECS injected secrets)
if [[ ! -n "${FLB_ES_HTTP_HOST}" ]]; then
  export FLB_ES_HTTP_HOST=$(cat /run/secrets/es-host.txt)
fi
if [[ ! -n "${FLB_ES_HTTP_PASSWD}" ]]; then
  export FLB_ES_HTTP_PASSWD=$(cat /run/secrets/es-pwd.txt)
fi

# setup_configs
if [ -f "/run/configs/fluent-beats.env" ]; then
  echo -e "\033[1;32m - Using env file\033[0m"
  cat /run/configs/fluent-beats.env
  export $(grep -v '^#' /run/configs/fluent-beats.env | xargs)
else
  echo -e "\033[1;33m - Using variables configs\033[0m"
  if [[ ! -n "${FLB_DOCKER_METRICS_INTERVAL}" ]]; then
    export FLB_DOCKER_METRICS_INTERVAL=10
  fi
    if [[ ! -n "${FLB_HOST_METRICS_INTERVAL}" ]]; then
    export FLB_HOST_METRICS_INTERVAL=10
  fi
  if [[ ! -n "${FLB_MEM_BUF_LIMIT}" ]]; then
    export FLB_MEM_BUF_LIMIT=3M
  fi
  if [[ ! -n "${FLB_FORWARD_BUF_CHUNK_SIZE}" ]]; then
    export FLB_FORWARD_BUF_CHUNK_SIZE=1M
  fi
  if [[ ! -n "${FLB_FORWARD_BUF_MAX_SIZE}" ]]; then
    export FLB_FORWARD_BUF_MAX_SIZE=3M
  fi
  if [[ ! -n "${FLB_STORAGE_BACKLOG_MEM_LIMIT}" ]]; then
    export FLB_STORAGE_BACKLOG_MEM_LIMIT=10M
  fi
  if [[ ! -n "${FLB_HOST_NET_INTERFACE}" ]]; then
    export FLB_HOST_NET_INTERFACE=eth0
  fi
fi

# setup_agent
export AGENT_ID=$(echo $RANDOM | md5sum | head -c 12)
export AGENT_HOST=$(hostname)
export AGENT_IP=$(ip route | grep ${FLB_HOST_NET_INTERFACE} | awk '/src/ { print $7 }')

# will always match host no matter what (eg --cpuset-cpus=)
export HOST_NUM_PROCS=$(grep -c processor /proc/cpuinfo)

echo "\n---------------------"
# start
exec /fluent-bit/bin/fluent-bit \
-c /fluent-bit/etc/fluent-bit.conf \
-e /fluent-bit/bin/flb-in_carbon.so \
-e /fluent-bit/bin/flb-in_docker_stats.so \
-e /fluent-bit/bin/flb-in_docker_info.so \
-e /fluent-bit/bin/flb-in_docker_system.so \
-e /fluent-bit/bin/flb-in_cpuinfo.so \
-e /fluent-bit/bin/flb-in_diskinfo.so \
-e /fluent-bit/bin/flb-in_meminfo.so \
-e /fluent-bit/bin/flb-in_netinfo.so \
-e /fluent-bit/bin/flb-in_load.so \