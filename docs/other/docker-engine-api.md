# Docker Engine API

In order to collect metrics from Docker containers, we need to access the [Docker Engine API](https://docs.docker.com/engine/api/v1.41/).

Here we describe the major endpoints that we can use to collect these informations.


## List all containers (used by Metricbeats to list all containers)

https://github.com/elastic/beats/tree/main/metricbeat/module/docker

```sh
curl --unix-socket /var/run/docker.sock http://localhost/containers/json
```

## Get container info MetricBeat -> (docker.container, docker.health)
```sh
curl --unix-socket /var/run/docker.sock http://localhost//containers/(id or name)/json
```

## Get container info MetricBeat -> (docker.cpu, docker.memory, docker.network)
```sh
curl --unix-socket /var/run/docker.sock http://localhost//containers/(id or name)/stats
```

## System wide info MetricBeat -> (docker.info)
```sh
curl --unix-socket /var/run/docker.sock http://localhost//info
```
