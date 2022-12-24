# extract secrets
if [[ ! -n  "${ES_HTTP_HOST}" ]]; then
  export ES_HTTP_HOST=$(cat $ES_HTTP_HOST_SECRET)
fi
if [[ ! -n  "${ES_HTTP_PASSWD}" ]]; then
  export ES_HTTP_PASSWD=$(cat $ES_HTTP_PWD_SECRET)
fi

# agent info
export AGENT_ID=$($RAMDOM | md5sum | head -c 12)
export AGENT_HOST=$(cat /proc/sys/kernel/hostname)

# start
exec /fluent-bit/bin/fluent-bit \
-c /fluent-bit/etc/fluent-bit.conf \
-e /fluent-bit/bin/flb-in_carbon.so \
-e /fluent-bit/bin/flb-in_docker_stats.so \
-e /fluent-bit/bin/flb-in_docker_info.so \
-e /fluent-bit/bin/flb-in_docker_system.so \