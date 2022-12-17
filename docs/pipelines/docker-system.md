# Components

- pipeline-system.conf
- system-ecs.lua

# Metricsets

## Info

The Docker info data stream collects system-wide information.

> `metricset.name: info`

### Exported fields

 Field                           | Description                                                                                    | Type             | Metric Type
---------------------------------|------------------------------------------------------------------------------------------------|------------------|-------------
 @timestamp                      | Event timestamp.                                                                               | date             |
 agent.id                        | Unique agent identifier.                                                                       | keyword          |
 agent.hostname                  | Name of the host where the agent is running.                                                   | keyword          |
 agent.name                      | Name of the agent.                                                                             | keyword          |
 container.id                    | Unique container id.                                                                           | keyword          |
 container.name                  | Container name.                                                                                | keyword          |
 container.runtime               | Runtime managing this container.                                                               | keyword          |
 docker.info.containers.paused   | Total number of paused containers.                                                             | long             | counter
 docker.info.containers.running  | Total number of running containers.                                                            | long             | counter
 docker.info.containers.stopped  | Total number of stopped containers                                                             | long             | counter
 docker.info.containers.total    | Total number of existing containers.                                                           | long             | counter
 docker.info.id                  | Unique Docker host identifier.                                                                 | keyword          |
 docker.info.images              | Total number of existing images.                                                               | long             | counter
 ecs.version                     | ECS version this event conforms to. ecs.version is a required field and must exist in all events. When querying across multiple indices -- which may conform to slightly different ECS versions -- this field lets integrations adjust to the schema version of the events.           | keyword          |
 event.dataset                   | Event dataset                                                                                  | constant_keyword |
 event.kind                      | Event kind                                                                                     | constant_keyword |
 event.module                    | Event module                                                                                   | constant_keyword |
 service.address                 | Address where data about this service was collected from. This should be a URI, network address (ipv4:port or [ipv6]:port) or a resource path (sockets).                                                                                                                       | keyword          |
 service.type                    | The type of the service data is collected from. The type can be used to group and correlate logs and metrics from one service type. Example: If logs or metrics are collected from Elasticsearch, service.type would be elasticsearch.                                                   | keyword          |