# Components

- pipeline-logs.conf
- logs-ecs.lua

# Target Data Stream

**metrics-docker.logs-default**

# Configurations

The logs pipeline relies on `FluentD Foward protocol` used to receive logs from Docker containers.

> This pipeline DOES NOT enforce, but will give best results with logs enconde in JSON.

Some configurations applied to the FluentD log driver are used to setup the integration with the pipeline.

## Labels

You can apply labels to logs, they will help to shard and segment your searches.

To define which labels must be added, simply :
1. prefix labels with `flb_`
2. inform the regex `"^flb_.*"` on driver option `labels-regex`

> These values can't be customized or modified.

## Tagging

FluentD log driver should use the tag `logs`, to match the internal pipeline tags.

### Container log configuration example

```yaml
  my-service:
      image: my-image
      labels:
        flb_env: "prod"
        flb_other_label: "my label"
      logging:
        driver: fluentd
        options:
          labels-regex: "^flb_.*"
          tag: logs

```

## Logs

Docker data stream that collects logs.

> `metricset.name: docker_log`

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
 data_stream.dataset             | Data stream dataset.                                                                           | constant_keyword
 data_stream.namespace           | Data stream namespace.                                                                         | constant_keyword
 data_stream.type                | Data stream type.                                                                              | constant_keyword
 ecs.version                     | ECS version this event conforms to. ecs.version is a required field and must exist in all events. When querying across multiple indices -- which may conform to slightly different ECS versions -- this field lets integrations adjust to the schema version of the events.           | keyword
 event.dataset                   | Event dataset.                                                                                 | constant_keyword
 event.kind                      | Event kind.                                                                                    | constant_keyword
 event.module                    | Event module.                                                                                  | constant_keyword
 host                            | A host is defined as a general computing instance. ECS host.* fields should be populated with details about the host on which the event happened, or from which the measurement was taken. Host types include hardware, virtual machines and Docker containers                             | group
 host.hostname                   | Hostname of the host. It normally contains what the hostname command returns on the hostmachine.                                                                                                                     | keyword
 host.ip                         | Host ip addresses.                                                                             | ip
 host.name                       | Name of the host. It can contain what hostname returns on Unix systems, the fully qualified domain name, or a name specified by the user. The sender decides which value to use.                                                                                                    | keyword          |
 labels.*                        | Subset of containers's labels, containing only those prefixed with `flb_`. These container prefixed labels can be used to filter the logs by specific features like enviroment, version or service name.                                                                               | object
 log.*                           | Contains all fields defined in JSON log entries, except by the `message` itself.               | object
 message                         | Contains the log message.                                                                      | text
 service.name                    | Service that produced the logs.                                                                | keyword