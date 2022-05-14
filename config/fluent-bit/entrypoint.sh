# export secret values
export ES_CLOUD_ID=$(cat $ES_CLOUD_ID_SECRET)
export ES_CLOUD_AUTH=$(cat $ES_CLOUD_AUTH_SECRET)

# start
exec /fluent-bit/bin/fluent-bit -c /fluent-bit/etc/fluent-bit.conf -e /fluent-bit/bin/flb-in_carbon.so