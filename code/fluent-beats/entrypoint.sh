echo "---------------------"
echo "Fluent Beats"

# extract_secrets (test variable to support ECS injected secrets)
if [[ ! -n  "${FLB_ES_HTTP_HOST}" ]]; then
  export FLB_ES_HTTP_HOST=$(cat /run/secrets/es-host.txt)
fi
if [[ ! -n  "${FLB_ES_HTTP_PASSWD}" ]]; then
  export FLB_ES_HTTP_PASSWD=$(cat /run/secrets/es-pwd.txt)
fi

# setup_configs
if [ -f "/run/configs/fluent-beats.env" ]; then
  echo -e "\033[1;32m - Using external configs\033[0m"
  export $(grep -v '^#' /run/configs/fluent-beats.env | xargs)
else
  echo -e "\033[1;33m - Using hardcoded configs\033[0m"
  export FLB_COLLECT_INTERVAL=10
  export FLB_MEM_BUF_LIMIT=10M
  export FLB_FORWARD_BUF_CHUNK_SIZE=1M
  export FLB_FORWARD_BUF_MAX_SIZE=6M
  export FLB_STORAGE_BACKLOG_MEM_LIMIT=5M
fi

# setup_agent
export AGENT_ID=$(echo $RANDOM | md5sum | head -c 12)
export AGENT_HOST=$(hostname)
export AGENT_IP=$(hostname -i)

echo "---------------------"
# start
exec /fluent-bit/bin/fluent-bit \
-c /fluent-bit/etc/fluent-bit.conf \
-e /fluent-bit/bin/flb-in_carbon.so \
-e /fluent-bit/bin/flb-in_docker_stats.so \
-e /fluent-bit/bin/flb-in_docker_info.so \
-e /fluent-bit/bin/flb-in_docker_system.so \
-e /fluent-bit/bin/flb-in_meminfo.so \
-e /fluent-bit/bin/flb-in_load.so \