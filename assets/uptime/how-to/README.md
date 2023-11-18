
## Create templates

```shell
docker run \
  --rm \
  --name=heartbeat \
  --user=heartbeat \
  --cap-add=NET_RAW \
  docker.elastic.co/beats/heartbeat:8.11.1 heartbeat setup -e \
  -E cloud.id={CLOUD_ID} \
  -E cloud.auth=elastic:{PASSORD}
```

## Produce valid uptimes

```shell
chmod go-w  heartbeat.docker.yml
docker run \
  --rm \
  --name=heartbeat \
  --user=heartbeat \
  --cap-add=NET_RAW \
  --volume="$(pwd)/heartbeat.docker.yml:/usr/share/heartbeat/heartbeat.yml:ro" \
  docker.elastic.co/beats/heartbeat:8.11.1 \
  -E cloud.id={CLOUD_ID} \
  -E cloud.auth=elastic:{PASSORD}
```