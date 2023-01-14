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
 data_stream.dataset             | Data stream dataset.                                                                           | constant_keyword |
 data_stream.namespace           | Data stream namespace.                                                                         | constant_keyword |
 data_stream.type                | Data stream type.                                                                              | constant_keyword |
 docker.info.containers.paused   | Total number of paused containers.                                                             | long             | counter
 docker.info.containers.running  | Total number of running containers.                                                            | long             | counter
 docker.info.containers.stopped  | Total number of stopped containers                                                             | long             | counter
 docker.info.containers.total    | Total number of existing containers.                                                           | long             | counter
 docker.info.id                  | Unique Docker host identifier.                                                                 | keyword          |
 docker.info.images              | Total number of existing images.                                                               | long             | counter
 ecs.version                     | ECS version this event conforms to. ecs.version is a required field and must exist in all events. When querying across multiple indices -- which may conform to slightly different ECS versions -- this field lets integrations adjust to the schema version of the events.           | keyword          |
 event.dataset                   | Event dataset.                                                                                 | constant_keyword |
 event.kind                      | Event kind.                                                                                    | constant_keyword |
 event.module                    | Event module.                                                                                  | constant_keyword            |
 host                            | A host is defined as a general computing instance. ECS host.* fields should be populated with details about the host on which the event happened, or from which the measurement was taken. Host types include hardware, virtual machines and Docker containers                             | group          |
 host.hostname                   | Hostname of the host. It normally contains what the hostname command returns on the hostmachine.                                                                                                                     | keyword        |
 host.ip                         | Host ip addresses.                                                                             | ip             |
 host.name                       | Name of the host. It can contain what hostname returns on Unix systems, the fully qualified domain name, or a name specified by the user. The sender decides which value to use.                                                                                                      | keyword        |
 service.address                 | Address where data about this service was collected from. This should be a URI, network address (ipv4:port or [ipv6]:port) or a resource path (sockets).                                                                                                                       | keyword          |
 service.type                    | The type of the service data is collected from. The type can be used to group and correlate logs and metrics from one service type. Example: If logs or metrics are collected from Elasticsearch, service.type would be elasticsearch.                                                   | keyword          |
