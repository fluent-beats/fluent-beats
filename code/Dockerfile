# Builder image
################################
FROM            amd64/debian:buster-slim as builder

ENV             DEBIAN_FRONTEND noninteractive
ARG             FLB_VERSION=1.8.4

# Setup toolchain
# -------------
RUN             mkdir -p /fluent-bit/bin /fluent-bit/etc /fluent-bit/log /tmp/fluent-bit-master/
RUN             apt-get update && \
                apt-get install -y --no-install-recommends \
                build-essential \
                curl \
                ca-certificates \
                cmake \
                make \
                tar \
                libssl-dev \
                libsasl2-dev \
                pkg-config \
                libsystemd-dev \
                zlib1g-dev \
                libpq-dev \
                postgresql-server-dev-all \
                flex \
                bison

# Download FluentBit sources
# -------------
WORKDIR         /usr/src/fluentbit
RUN             curl -Lo /tmp/fluentbit.tgz https://github.com/fluent/fluent-bit/archive/v${FLB_VERSION}.tar.gz && \
                tar xf /tmp/fluentbit.tgz

# Build custom FluentBit (https://docs.fluentbit.io/manual/v/1.8/installation/sources/build-and-install)
# -------------
WORKDIR         /usr/src/fluentbit/fluent-bit-${FLB_VERSION}/build
# use minimal plugins (the commented ones)
RUN             cmake -DFLB_RELEASE=On \
                      -DFLB_TRACE=Off \
                      -DFLB_JEMALLOC=On \
                      -DFLB_TLS=On \
                      -DFLB_SHARED_LIB=Off \
                      -DFLB_EXAMPLES=Off \
                      -DFLB_HTTP_SERVER=On \
                      -DFLB_STREAM_PROCESSOR=Off \
                      # input plugins
                      -DFLB_IN_COLLECTD=Off \
                      -DFLB_IN_CPU=Off \
                      -DFLB_IN_DISK=Off \
                      -DFLB_IN_DOCKER=Off \
                      -DFLB_IN_EXEC=Off \
                      #-DFLB_IN_FORWARD=On \
                      -DFLB_IN_HEAD=Off \
                      -DFLB_IN_HEALTH=Off \
                      -DFLB_IN_KMSG=Off \
                      -DFLB_IN_MEM=Off \
                      -DFLB_IN_MQTT=Off \
                      #-DFLB_IN_NETIF=On \
                      -DFLB_IN_PROC=Off \
                      -DFLB_IN_RANDOM=Off \
                      -DFLB_IN_SERIAL=Off \
                      -DFLB_IN_STDIN=Off \
                      -DFLB_IN_SYSLOG=Off \
                      -DFLB_IN_SYSTEMD=Off \
                      -DFLB_IN_TAIL=Off \
                      -DFLB_IN_TCP=Off \
                      -DFLB_IN_THERMAL=Off \
                      -DFLB_IN_WINLOG=Off \
                      # output plugins
                      -DFLB_OUT_AZURE=Off \
                      -DFLB_OUT_BIGQUERY=Off \
                      -DFLB_OUT_COUNTER=Off \
                      -DFLB_OUT_CLOUDWATCH_LOGS=Off \
                      -DFLB_OUT_DATADOG=Off \
                      #-DFLB_OUT_ES=On \
                      -DFLB_OUT_FILE=Off \
                      -DFLB_OUT_KINESIS_FIREHOSE=Off \
                      -DFLB_OUT_KINESIS_STREAMS=Off \
                      -DFLB_OUT_FLOWCOUNTER=Off \
                      -DFLB_OUT_FORWARD=Off \
                      -DFLB_OUT_GELF=Off \
                      -DFLB_OUT_HTTP=Off \
                      -DFLB_OUT_INFLUXDB=Off \
                      -DFLB_OUT_KAFKA=Off \
                      -DFLB_OUT_KAFKA_REST=Off \
                      #-DFLB_OUT_LIB=On \
                      -DFLB_OUT_NATS=Off \
                      #-DFLB_OUT_NULL=On \
                      -DFLB_OUT_PGSQL=Off \
                      -DFLB_OUT_PLOT=Off \
                      -DFLB_OUT_SLACK=Off \
                      -DFLB_OUT_S3=Off \
                      -DFLB_OUT_SPLUNK=Off \
                      -DFLB_OUT_STACKDRIVER=Off \
                      #-DFLB_OUT_STDOUT=On \
                      -DFLB_OUT_TCP=Off \
                      -DFLB_OUT_TD=Off ..

RUN             make -j $(getconf _NPROCESSORS_ONLN)
RUN             install bin/fluent-bit /fluent-bit/bin/

# Install Busybox
# -------------
COPY            --from=amd64/busybox:1.31.1 /bin/busybox /bin/busybox
RUN             chmod 555 /bin/busybox && \
                /bin/busybox --install -s /usr/local/bin

# Target image
################################

FROM            gcr.io/distroless/cc-debian10

# Fluent Bit
# -------------
# certificates
COPY            --from=builder /usr/share/ca-certificates/  /usr/share/ca-certificates/
COPY            --from=builder /etc/ssl/ /etc/ssl/
# ssl stuff
COPY            --from=builder /usr/lib/x86_64-linux-gnu/*sasl* /usr/lib/x86_64-linux-gnu/
COPY            --from=builder /usr/lib/x86_64-linux-gnu/libz* /usr/lib/x86_64-linux-gnu/
COPY            --from=builder /lib/x86_64-linux-gnu/libz* /lib/x86_64-linux-gnu/
COPY            --from=builder /usr/lib/x86_64-linux-gnu/libssl.so* /usr/lib/x86_64-linux-gnu/
COPY            --from=builder /usr/lib/x86_64-linux-gnu/libcrypto.so* /usr/lib/x86_64-linux-gnu/
# binaries
COPY            --from=builder /fluent-bit /fluent-bit
COPY            --from=builder /usr/local/bin/ /usr/local/bin/
COPY            --from=builder /bin/busybox /bin/

# Fluent Beats
# -------------
# configs/pipelines
COPY            /fluent-beats/config/*.conf /fluent-bit/etc/
COPY            /fluent-beats/pipelines/apm/*.* /fluent-bit/etc/
COPY            /fluent-beats/pipelines/host/*.* /fluent-bit/etc/
COPY            /fluent-beats/pipelines/docker-info/*.* /fluent-bit/etc/
COPY            /fluent-beats/pipelines/docker-logs/*.* /fluent-bit/etc/
COPY            /fluent-beats/pipelines/docker-stats/*.* /fluent-bit/etc/
COPY            /fluent-beats/pipelines/docker-system/*.* /fluent-bit/etc/
# binaries
COPY            /fluent-beats/plugins/*.* /fluent-bit/bin/
# entrypoint
COPY            /fluent-beats/entrypoint.sh /entrypoint.sh


# Run
# -------------
EXPOSE          2020
ENTRYPOINT      ["sh", "/entrypoint.sh"]