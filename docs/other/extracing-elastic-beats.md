# Extracting Elastic Beats Index Templates

Index templates provide the contract used by Beats plugins to ship data into Elastichsearch clusters.

Here we describe how to extract index templates for major Elastic Beats plugins.


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