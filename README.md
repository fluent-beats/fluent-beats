# Description

Observability service used to collect **logs**, **metrics**, **apm** and **heartbeats** from Docker / Docker Swarm and ship them into [Elastic Cloud](https://www.elastic.co) using [FluentBit](https://fluentbit.io/) instead native [Elastic Beats](https://www.elastic.co/beats/).

# Requirements

* [Docker](www.docker.com)
* [Docker Swarm Mode](https://docs.docker.com/engine/swarm/)
* [FluentBit Carbon Plugin](https://github.com/fluent-beats/fluent-bit-carbon)
* [FluentBit Docker Stats Plugin](https://github.com/fluent-beats/fluent-bit-docker-stats)

# Design

This service is designed to provide ligthweight observability capababilities.

Its deployed as a [Docker Swarm Global Service](https://docs.docker.com/engine/swarm/services/#replicated-or-global-services) inside a Docker cluster in order to receive any type of observability information from other services.

## Container requirements

To work properly the container requires:

* Port bindings:
    * `24224/tcp`: Used to receive Logs from Docker Fluentd Driver
    * `8125/udp`: Used to receive Metrics/APM using extended StatsD datagrams (StatsD  + Tags)
* Volumes:
    * `/var/run/docker.sock`: Used to call Docker engine API
    * `/var/lib/docker/containers`: Used to detect all container running in the host


## Container capabilities
Its able to handle 4 main workflows:

### Logs

Logs collection relies on features provided by [Docker Fluentd Driver](https://docs.docker.com/config/containers/logging/fluentd/) allowing containers to ship their logs to underline `host node`.

The Docker Fluentd Driver can be configured to ship custom tags, so logs can be sharded into buckets just like Metrics.


### APM

APM collection relies on extended StatsD datagrams.

To support it the service uses a custom plugin [FluentBit Carbon Plugin](https://github.com/fluent-beats/fluent-bit-carbon), that can parse the extended datagram properly.

### Metrics

This service is able to collect metrics form all Docker container running in the same `host node`.

To support it the service uses a custom plugin [FluentBit Docker Stats Plugin](https://github.com/fluent-beats/fluent-bit-docker-stats), that can
access Docker Engine API and collect stats about **CPU**, **Memory** and **Network**.

**Memory Stats**

Memory stats are computed using same math used by `docker container stats` command, as follows:

* `memory.usage` = **memory_stats.usage**
* `memory.used` = **memory_stats.usage** - **memory_stats.stats.cache**
* `memory.available` = **memory_stats.limit**
* `memory.percent_usage` = (`memory.used`  / `memory.available`) * 100.0

**CPU Stats**

CPU stats are computed using same math used by `docker container stats` command, as follows:

* `cpu.delta` = **cpu_stats.cpu_usage.total_usage** - **precpu_stats.cpu_usage.total_usage**
* `cpu.system.delta` = **cpu_stats.system_cpu_usage** - **precpu_stats.system_cpu_usage**
* `cpu.counter` = **cpu_stats.online_cpus**
* `cpu.percent_usage` = (`cpu.delta` / `cpu.system.delta`) * `cpu.counter` * 100.0

**Network Stats**

* `network.ingress.bytes` = sum(**networks[*].rx_bytes**)
* `network.egress.bytes` = sum(**networks[*].tx_bytes**)

**Disk Stats**

* `disk.read.bytes` = **blkio_stats.io_service_bytes_recursive[?(@.op=='Read')].value**
* `disk.write.bytes` = **blkio_stats.io_service_bytes_recursive[?(@.op=='Read')].value**

### Health checks

TODO

## Testing locally
``` bash
docker-compose -f docker-compose-test.yml up
echo "click;env=prod;service=my-service:11|c|@0.1" | nc -w0 -q0 -u 127.0.0.1 8125
```

## Notes about Fluent Bit

- The `Fluent Bit` version used on this project is `1.8.11`, versions up to `1.8.11` are shipped as much bigger Docker images. These versions do not provide any useful feature for this particular design/solution (keep away from them).
- In order to apply `Docker Secrets` extraction, the `Fluent Bit` Docker image version must include shell support (debug flavor). Again versions up to `1.8.11-debug` **look more like an elephant than an hummingbird** (keep away from them).


## Notes about Elastic Cloud

- The container uses [Elastic ECS](https://www.elastic.co/guide/en/ecs/current/index.html) to translate incomming logs, events and metrics in order to properly ingestion on Elasticsearch.