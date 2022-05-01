# Hacking Beats Index and Events


## MetricBeat

### Extract MetricBeat Index Template

- Run MetricBeat container
```sh
docker run --rm -ti docker.elastic.co/beats/metricbeat:8.0.0
```

- Export template manually
```sh
docker container exec -it CONTAINER_ID ./metricbeat export template > metricbeat.template.json
```

- Import template manually
```sh
curl -XPUT -H 'Content-Type: application/json' http://localhost:9200/_index_template/metricbeat-8.0.1 -d@metricbeat.template.json
```

### Understand MetricBeat Event Format

> https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-event-structure.html

____

## FileBeat

- Run FileBeat container
```sh
docker run --rm -ti docker.elastic.co/beats/filebeat:8.0.0
```

- Export template manually
```sh
docker container exec -it CONTAINER_ID ./filebeat export template > filebeat.template.json
```

- Import template manually
```sh
curl -XPUT -H 'Content-Type: application/json' http://localhost:9200/_index_template/filebeat-8.0.1 -d@filebeat.template.json
```


____

## Extend FluentBit

### Access Docker API

https://docs.docker.com/engine/api/v1.41/
https://github.com/elastic/beats/tree/main/metricbeat/module/docker

List all containers (used by Metricbeats to list all containers)
```sh
curl --unix-socket /var/run/docker.sock http://localhost/containers/json
```

Get container info MetricBeat -> (docker.container, docker.health)
```sh
curl --unix-socket /var/run/docker.sock http://localhost//containers/(id or name)/json
```

Get container info MetricBeat -> (docker.cpu, docker.memory, docker.network)
```sh
curl --unix-socket /var/run/docker.sock http://localhost//containers/(id or name)/stats
```

System wide info MetricBeat -> (docker.info)
```sh
curl --unix-socket /var/run/docker.sock http://localhost//info
```
