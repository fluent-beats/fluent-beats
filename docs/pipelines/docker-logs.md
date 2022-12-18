# Components

- pipeline-logs.conf
- logs-ecs.lua

# Design

Logs rely on `FluentD Foward protocol` used to receive logs from Docker containers.

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
 ecs.version                     | ECS version this event conforms to. ecs.version is a required field and must exist in all events. When querying across multiple indices -- which may conform to slightly different ECS versions -- this field lets integrations adjust to the schema version of the events.           | keyword          |
 event.dataset                   | Event dataset.                                                                                 | constant_keyword |
 event.kind                      | Event kind.                                                                                    | constant_keyword |
 event.module                    | Event module.                                                                                  | constant_keyword |
 labels.*                        | Subset of containers's labels, containing only those prefixed with `flb_`. These container prefixed labels can be used to filter the logs by specific features like enviroment, version or service name.                                                                               | object           |
 message                         | Contains the log message, optimized for viewing in a log viewer.                               | text             |
 service.name                    | Service that produced the logs.                                                                | keyword          |
 stream                          | Log stream name.                                                                               | keyword          |