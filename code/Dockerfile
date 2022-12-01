FROM            fluent/fluent-bit:1.8.4-debug

# Config
COPY            /fluent-beats/config/*.conf /fluent-bit/etc/

# Pipelines
COPY            /fluent-beats/pipelines/apm/*.* /fluent-bit/etc/
COPY            /fluent-beats/pipelines/info/*.* /fluent-bit/etc/
COPY            /fluent-beats/pipelines/logs/*.* /fluent-bit/etc/
COPY            /fluent-beats/pipelines/metrics/*.* /fluent-bit/etc/

# Plugins
COPY            /fluent-beats/plugins/*.* /fluent-bit/bin/

# Entrypoint
COPY            /fluent-beats/entrypoint.sh /entrypoint.sh

# Run
ENTRYPOINT      ["sh", "/entrypoint.sh"]
