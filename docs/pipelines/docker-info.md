# Components

- pipeline-info.conf
- info-ecs.lua

# Target Data Stream

**metrics-docker.info-default**

# Metricsets

## Container

Docker data stream that collects info about containers.

> `metricset.name: docker_container`

### Exported fields

 Field                         | Description                                                                                    | Type             | Metric Type
-------------------------------|------------------------------------------------------------------------------------------------|------------------|-------------
 @timestamp                    | Event timestamp.                                                                               | date             |
 agent.id                      | Unique agent identifier.                                                                       | keyword          |
 agent.hostname                | Name of the host where the agent is running.                                                   | keyword          |
 agent.name                    | Name of the agent.                                                                             | keyword          |
 container.id                  | Unique container id.                                                                           | keyword          |
 container.name                | Container name.                                                                                | keyword          |
 container.runtime             | Runtime managing this container.                                                               | keyword          |
 data_stream.dataset           | Data stream dataset.                                                                           | constant_keyword |
 data_stream.namespace         | Data stream namespace.                                                                         | constant_keyword |
 data_stream.type              | Data stream type.                                                                              | constant_keyword |
 docker.container.command      | Command that was executed in the Docker container.                                             | keyword          |
 docker.container.created      | Date when the container was created.                                                           | date             |
 docker.container.ip_addresses | Container IP addresses.                                                                        | ip               |
 ~~docker.container.labels.*~~ | Container labels                                                                               | object           |
 docker.container.size.root_fs | Total size of all the files in the container.                                                  | long             | gauge
 docker.container.size.rw      | Size of the files that have been created or changed since creation.                            | long             | gauge
 docker.container.status       | Container status.                                                                              | keyword          |
 ecs.version                   | ECS version this event conforms to. ecs.version is a required field and must exist in all events. When querying across multiple indices -- which may conform to slightly different ECS versions -- this field lets integrations adjust to the schema version of the events.         | keyword          |
 event.dataset                 | Event dataset.                                                                                 | constant_keyword |
 event.kind                    | Event kind.                                                                                    | constant_keyword |
 event.module                  | Event module.                                                                                  | constant_keyword |
 host                          | A host is defined as a general computing instance. ECS host.* fields should be populated with details about the host on which the event happened, or from which the measurement was taken. Host types include hardware, virtual machines and Docker containers                           | group            |
 host.hostname                 | Hostname of the host. It normally contains what the hostname command returns on the hostmachine.                                                                                                                   | keyword          |
 host.ip                       | Host ip addresses.                                                                             | ip               |
 host.name                     | Name of the host. It can contain what hostname returns on Unix systems, the fully qualified domain name, or a name specified by the user. The sender decides which value to use.                                                                                                    | keyword          |
 service.address               | Address where data about this service was collected from. This should be a URI, network address (ipv4:port or [ipv6]:port) or a resource path (sockets).                                                                                                                     | keyword          |
 service.type                  | The type of the service data is collected from. The type can be used to group and correlate logs and metrics from one service type. Example: If logs or metrics are collected from Elasticsearch, service.type would be elasticsearch.                                                 | keyword          |

> docker.container.labels.* must be enabled using `FLB_COLLECT_CONTAINER_LABELS=true`

---

## Healthcheck

Docker data stream that collects healthcheck from containers.

Healthcheck data will only be available from Docker containers where the Docker `HEALTHCHECK` instruction has been used to build the Docker image.

> `metricset.name: docker_healthcheck`

### Exported fields

 Field                               | Description                                                                                    | Type             | Metric Type
-------------------------------------|------------------------------------------------------------------------------------------------|------------------|-------------
 @timestamp                          | Event timestamp.                                                                               | date             |
 agent.id                            | Unique agent identifier.                                                                       | keyword          |
 agent.hostname                      | Name of the host where the agent is running.                                                   | keyword          |
 agent.name                          | Name of the agent.                                                                             | keyword          |
 container.id                        | Unique container id.                                                                           | keyword          |
 container.name                      | Container name.                                                                                | keyword          |
 container.runtime                   | Runtime managing this container.                                                               | keyword          |
 docker.healthcheck.event.end_date   | Healthcheck end date                                                                           | date             |
 docker.healthcheck.event.exit_code  | Healthcheck status code                                                                        | integer          |
 docker.healthcheck.event.output     | Healthcheck output                                                                             | keyword          |
 docker.healthcheck.event.start_date | Healthcheck start date                                                                         | date             |
 docker.healthcheck.failingstreak    | concurent failed check                                                                         | integer          | counter
 docker.healthcheck.status           | Healthcheck status code                                                                        | keyword          |
 ecs.version                         | ECS version this event conforms to. ecs.version is a required field and must exist in all events. When querying across multiple indices -- which may conform to slightly different ECS versions -- this field lets integrations adjust to the schema version of the events.               | keyword          |
 event.dataset                       | Event dataset.                                                                                 | constant_keyword |
 event.kind                          | Event kind.                                                                                    | constant_keyword |
 event.module                        | Event module.                                                                                  | constant_keyword |
 host                                | A host is defined as a general computing instance. ECS host.* fields should be populated with details about the host on which the event happened, or from which the measurement was taken. Host types include hardware, virtual machines and Docker containers                            | group            |
 host.hostname                       | Hostname of the host. It normally contains what the hostname command returns on the hostmachine.                                                                                                                         | keyword          |
 host.ip                             | Host ip addresses.                                                                             | ip               |
 host.name                           | Name of the host. It can contain what hostname returns on Unix systems, the fully qualified domain name, or a name specified by the user. The sender decides which value to use.                                                                                                          | keyword          |
 service.address                     | Address where data about this service was collected from. This should be a URI, network address (ipv4:port or [ipv6]:port) or a resource path (sockets).                                                                                                                           | keyword          |
 service.type                        | The type of the service data is collected from. The type can be used to group and correlate logs and metrics from one service type. Example: If logs or metrics are collected from Elasticsearch, service.type would be elasticsearch.                                                    | keyword          |

---

## Image

Docker data stream that collects info about images.

> `metricset.name: docker_image`

### Exported fields

 Field                               | Description                                                                                    | Type             | Metric Type
-------------------------------------|------------------------------------------------------------------------------------------------|------------------|-------------
 @timestamp                          | Event timestamp.                                                                               | date             |
 agent.id                            | Unique agent identifier.                                                                       | keyword          |
 agent.hostname                      | Name of the host where the agent is running.                                                   | keyword          |
 agent.name                          | Name of the agent.                                                                             | keyword          |
 container.id                        | Unique container id.                                                                           | keyword          |
 container.image.name                | Name of the image the container was built on.                                                  | keyword          |
 container.name                      | Container name.                                                                                | keyword          |
 container.runtime                   | Runtime managing this container.                                                               | keyword          |
 ecs.version                         | ECS version this event conforms to. ecs.version is a required field and must exist in all events. When querying across multiple indices -- which may conform to slightly different ECS versions -- this field lets integrations adjust to the schema version of the events.               | keyword          |
 event.dataset                       | Event dataset.                                                                                 | constant_keyword |
 event.kind                          | Event kind.                                                                                    | constant_keyword |
 event.module                        | Event module.                                                                                  | constant_keyword |
 host                                | A host is defined as a general computing instance. ECS host.* fields should be populated with details about the host on which the event happened, or from which the measurement was taken. Host types include hardware, virtual machines and Docker containers                            | group            |
 host.hostname                       | Hostname of the host. It normally contains what the hostname command returns on the hostmachine.                                                                                                                         | keyword          |
 host.ip                             | Host ip addresses.                                                                             | ip               |
 host.name                           | Name of the host. It can contain what hostname returns on Unix systems, the fully qualified domain name, or a name specified by the user. The sender decides which value to use.                                                                                                          | keyword          |
 service.address                     | Address where data about this service was collected from. This should be a URI, network address (ipv4:port or [ipv6]:port) or a resource path (sockets).                                                                                                                           | keyword          |
 service.type                        | The type of the service data is collected from. The type can be used to group and correlate logs and metrics from one service type. Example: If logs or metrics are collected from Elasticsearch, service.type would be elasticsearch.                                                    | keyword          |
