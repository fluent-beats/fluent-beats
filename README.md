# Description

<p align="center">
 <img src="https://raw.githubusercontent.com/fluent-beats/fluent-beats/master/docs/img/fluent-beats.png" width="927"/>
</p>

Observability service used to collect **logs**, **metrics**, **apm** and **heartbeats** from Docker containers and ship them into [Elastic Cloud](https://www.elastic.co) using [FluentBit](https://fluentbit.io/) instead native [Elastic Beats](https://www.elastic.co/beats/).

# Requirements

* [Docker](www.docker.com)
* [FluentBit Carbon Plugin](https://github.com/fluent-beats/fluent-bit-carbon)
* [FluentBit Docker Stats Plugin](https://github.com/fluent-beats/fluent-bit-docker-stats)

# Supported Orchestrators
- [Docker Swarm Mode](https://docs.docker.com/engine/swarm/)
- [AWS ECS](https://docs.aws.amazon.com/ecs/)

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

### Log

Logs collection relies on features provided by [Docker Fluentd Driver](https://docs.docker.com/config/containers/logging/fluentd/) allowing containers to ship their logs to underline `host node`.

The Docker Fluentd Driver can be configured to ship custom tags, so logs can be sharded into buckets just like Metrics.


### APM

APM collection relies on extended StatsD datagrams.

To support it the service uses a custom plugin [FluentBit Carbon Plugin](https://github.com/fluent-beats/fluent-bit-carbon), that can parse the extended datagram properly.

### Metrics

This service is able to collect metrics form all Docker container running in the same `host node`.

To support it the service uses a custom plugin [FluentBit Docker Stats Plugin](https://github.com/fluent-beats/fluent-bit-docker-stats), that can
access Docker Engine API and collect stats for:

* Memory
* CPU
* Network
* Disk

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


## Notes about Elasticsearch

- The container uses [Elastic ECS](https://www.elastic.co/guide/en/ecs/current/index.html) to translate incomming logs, events and metrics in order to properly ingestion on Elasticsearch.