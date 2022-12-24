# Components

- pipeline-logs.conf
- logs-ecs.lua

# Design

Logs rely on `FluentD Foward protocol` used to receive logs from Docker containers.

This pipeline DOES NOT enforce, but will give best results with logs in JSON format.


### Exported fields

 Field                           | Description                                                                                    | Type
---------------------------------|------------------------------------------------------------------------------------------------|------------------
 @timestamp                      | Event timestamp.                                                                               | date
 agent.id                        | Unique agent identifier.                                                                       | keyword
 agent.hostname                  | Name of the host where the agent is running.                                                   | keyword
 agent.name                      | Name of the agent.                                                                             | keyword
 container.id                    | Unique container id.                                                                           | keyword
 container.name                  | Container name.                                                                                | keyword
 container.runtime               | Runtime managing this container.                                                               | keyword
 ecs.version                     | ECS version this event conforms to. ecs.version is a required field and must exist in all events. When querying across multiple indices -- which may conform to slightly different ECS versions -- this field lets integrations adjust to the schema version of the events.           | keyword
 event.dataset                   | Event dataset.                                                                                 | constant_keyword
 event.kind                      | Event kind.                                                                                    | constant_keyword
 event.module                    | Event module.                                                                                  | constant_keyword
 labels.*                        | Subset of containers's labels, containing only those prefixed with `flb_`. These container prefixed labels can be used to filter the logs by specific features like enviroment, version or service name.                                                                               | object
 log.*                           | Contains all fields defined in JSON log entries, except by the `message` itself.               | object
 message                         | Contains the log message.                                                                      | text
 service.name                    | Service that produced the logs.                                                                | keyword