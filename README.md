# Description

Observability service used to collect **logs**, **metrics** and **apm** from Docker / Docker Swarm using and ship them into [Elastic Cloud](https://www.elastic.co) using [FluentBit](https://fluentbit.io/) instead native [Elastic Beats](https://www.elastic.co/beats/).

# Requirements

* [Docker](www.docker.com)
* [FluentBit Carbon Plugin](https://github.com/etriphany/fluent-bit-carbon)

# Design

This service is designed to provide ligthweight observability capababilities.

Its deployed as a [Docker Swarm Global Service](https://docs.docker.com/engine/swarm/services/#replicated-or-global-services) inside a Docker cluster in order to receive any type of observability information from other services.

It uses 2 port bindings to work
* 24224/tcp: Used to receive Logs from Docker Fluentd Driver
* 8125/udp: Used to receive Metrics/APM using extended StatsD datagrams (StatsD  + Tags)

Its able to handle 4 main workflows:

## Logs

Logs collection relies on features provided by [Docker Fluentd Driver](https://docs.docker.com/config/containers/logging/fluentd/) allowing containers to ship their logs to underline `host node`.

The Docker Fluentd Driver can be configured to ship custom tags, so logs can be sharded into buckets just like Metrics.


## APM

APM collection relies on extended StatsD datagrams.

To support it the service uses a custom plugin [FluentBit Carbon Plugin](https://github.com/etriphany/fluent-bit-carbon), that can parse the extended datagram properly.

## Metrics

This service is able to collect metrics form all Docker container running in the same `host node`.

To support it the service uses a custom plugin that access Docker Engine APi and collect stats about **CPU**, **Memory** and **Network**.

## Health checks


## Testing Locally
``` bash
docker-compose -f docker-compose-test.yml up
echo "click;env=prod;service=my-service:11|c|@0.1" | nc -w0 -q0 -u 127.0.0.1 8125
```
