# export secret values
export ES_HTTP_HOST=$(cat $ES_HTTP_HOST_SECRET)
export ES_HTTP_PASSWD=$(cat $ES_HTTP_PWD_SECRET)

# start
exec /fluent-bit/bin/fluent-bit \
 -c /fluent-bit/etc/fluent-bit.conf \
 -e /fluent-bit/bin/flb-in_carbon.so \
 -e /fluent-bit/bin/flb-in_docker_stats.so \
 -e /fluent-bit/bin/flb-in_docker_info.so \