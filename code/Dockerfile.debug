FROM            fluent/fluent-bit:1.8.4-debug

# Config
COPY            /fluent-beats/config/*.conf /fluent-bit/etc/

# Pipelines
COPY            /fluent-beats/pipelines/apm/*.* /fluent-bit/etc/
COPY            /fluent-beats/pipelines/docker-info/*.* /fluent-bit/etc/
COPY            /fluent-beats/pipelines/docker-logs/*.* /fluent-bit/etc/
COPY            /fluent-beats/pipelines/docker-stats/*.* /fluent-bit/etc/
COPY            /fluent-beats/pipelines/docker-system/*.* /fluent-bit/etc/

# Plugins
COPY            /fluent-beats/plugins/*.* /fluent-bit/bin/

# Entrypoint
COPY            /fluent-beats/entrypoint.sh /entrypoint.sh

# Run
ENTRYPOINT      ["sh", "/entrypoint.sh"]
