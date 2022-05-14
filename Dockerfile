FROM            fluent/fluent-bit:1.8.4-debug

# Plugins
COPY            /config/fluent-bit/plugins/flb-in_carbon.so /fluent-bit/bin/flb-in_carbon.so

# Pipelines
COPY            /config/fluent-bit/pipelines/apm/*.* /fluent-bit/etc/
COPY            /config/fluent-bit/pipelines/logs/*.* /fluent-bit/etc/
COPY            /config/fluent-bit/pipelines/metrics/*.* /fluent-bit/etc/

# Config
COPY            /config/fluent-bit/fluent-bit.conf /fluent-bit/etc/

# Run
CMD             ["/fluent-bit/bin/fluent-bit", "-c", "/fluent-bit/etc/fluent-bit.conf", "-e", "/fluent-bit/bin/flb-in_carbon.so"]
