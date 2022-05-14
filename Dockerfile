FROM            fluent/fluent-bit:1.8.4-debug

# Config
COPY            /config/fluent-bit/config/*.conf /fluent-bit/etc/

# Pipelines
COPY            /config/fluent-bit/pipelines/apm/*.* /fluent-bit/etc/
COPY            /config/fluent-bit/pipelines/logs/*.* /fluent-bit/etc/
COPY            /config/fluent-bit/pipelines/metrics/*.* /fluent-bit/etc/

# Plugins
COPY            /config/fluent-bit/plugins/*.* /fluent-bit/bin/

# Entrypoint
COPY            /config/fluent-bit/entrypoint.sh /entrypoint.sh

# Run
ENTRYPOINT      ["sh", "/entrypoint.sh"]
