# Description

`Fluent Beats` is a set of observability pipelines for **Docker Containers**, that replace [Elastic Beats](https://www.elastic.co/beats/) by its lightweight competitor [FluentBit](https://fluentbit.io/), to ship them into [Elastic Stack](https://www.elastic.co/elastic-stack/)

# Requirements

* [Docker](www.docker.com)

# Supported Orchestrators
- [Docker Swarm Mode](https://docs.docker.com/engine/swarm/)
- [AWS ECS](https://docs.aws.amazon.com/ecs/)

# Design

This service is designed to provide ligthweight observability capababilities for microservices running as Docker containers.

Its was designed to be deployed as a [Docker Swarm Global Service](https://docs.docker.com/engine/swarm/services/#replicated-or-global-services); or [AWS ECS equivalent](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_services.html#service_scheduler_daemon); in order to receive any type of observability information from other services.

Internally it translates all metrics and logs to [Elastic ECS](https://www.elastic.co/guide/en/ecs/current/index.html), which is the standard schema used by **Elasticsearch**

## Requirements

To work properly it requires:

* Port bindings:
    * `24224/tcp`: Used to receive Logs from Docker Fluentd Driver
    * `8125/udp`: Used to receive Metrics/APM using extended StatsD datagrams (StatsD  + Tags)
* Volumes:
    * `/var/run/docker.sock`: Used to call Docker engine API
    * `/var/lib/docker/containers`: Used to detect all container running in the host


## Featured pipelines

- [Docker Logs](https://github.com/fluent-beats/fluent-beats/blob/master/docs/pipelines/docker-logs.md)
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

- The `Fluent Bit` version used by this project is `1.8.4`
  - In order to apply `Docker Secrets` extraction, the `Fluent Bit` Docker image version must include shell support (debug flavor).
- Versions up to `1.8.11` are shipped as much bigger Docker images and don't provide any useful feature for this particular solution
  - Versions up to `1.8.11-debug` **are huge and not useful at all**.
