# Description

Observability service used to collect **logs**, **metrics**, **apm** and **heartbeats** from Docker containers and ship them into [ElasticSearch](https://www.elastic.co) using [FluentBit](https://fluentbit.io/) instead native [Elastic Beats](https://www.elastic.co/beats/).

# Requirements

* [Docker](www.docker.com)
* [FluentBit Carbon Plugin](https://github.com/fluent-beats/fluent-bit-carbon)
* [FluentBit Docker Stats Plugin](https://github.com/fluent-beats/fluent-bit-docker-stats)
* [FluentBit Docker Info Plugin](https://github.com/fluent-beats/fluent-bit-docker-info)
* [FluentBit Docker System Plugin](https://github.com/fluent-beats/fluent-bit-docker-system)

# Supported Orchestrators
- [Docker Swarm Mode](https://docs.docker.com/engine/swarm/)
- [AWS ECS](https://docs.aws.amazon.com/ecs/)

# Design

This service is designed to provide ligthweight observability capababilities.

Its was desined to be deployed as a [Docker Swarm Global Service](https://docs.docker.com/engine/swarm/services/#replicated-or-global-services), or equivalent, inside a Docker cluster in order to receive any type of observability information from other services.

## Requirements

To work properly it requires:

* Port bindings:
    * `24224/tcp`: Used to receive Logs from Docker Fluentd Driver
    * `8125/udp`: Used to receive Metrics/APM using extended StatsD datagrams (StatsD  + Tags)
* Volumes:
    * `/var/run/docker.sock`: Used to call Docker engine API
    * `/var/lib/docker/containers`: Used to detect all container running in the host


## Features

- [Logs](https://github.com/fluent-beats/fluent-beats/blob/master/docs/pipelines/docker-logs.md)
- [Docker Container Info](https://github.com/fluent-beats/fluent-beats/blob/master/docs/pipelines/docker-info.md)
- [Docker Container Stats](https://github.com/fluent-beats/fluent-beats/blob/master/docs/pipelines/docker-stats.md)
- [Docker System](https://github.com/fluent-beats/fluent-beats/blob/master/docs/pipelines/docker-system.md)
- [APM](https://github.com/fluent-beats/fluent-beats/blob/master/docs/pipelines/apm.md)


## Build

TODO

## Testing locally

The project contains a test stack, it requires properly configuration of Elasticsearch secrets by creating 2 files.

- `/test/secrets/http_host.txt`: contains the ES hostname
- `/test./secrets/http_host.txt`: contains the ES password

Once configured the test stack can be started:

``` bash
docker-compose -f docker-compose-test.yml up
```

## Notes about Fluent Bit

- The `Fluent Bit` version used on this project is `1.8.11`, versions up to `1.8.11` are shipped as much bigger Docker images. These versions do not provide any useful feature for this particular design/solution (keep away from them).
- In order to apply `Docker Secrets` extraction, the `Fluent Bit` Docker image version must include shell support (debug flavor). Again versions up to `1.8.11-debug` **look more like an elephant than an hummingbird** (keep away from them).


## Notes about Elasticsearch

- The container uses [Elastic ECS](https://www.elastic.co/guide/en/ecs/current/index.html) to translate incomming logs, events and metrics in order to properly ingestion on Elasticsearch.