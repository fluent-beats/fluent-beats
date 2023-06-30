# Components

- pipeline-apm.conf
- apm-ecs.lua

# Target Data Stream

**metrics-apm.stats-default**

# Configurations

The APM metrics relies on `statsd` datagrams, sent to Fluent Beats by external application.

The pipeline supports the following `statsd` datagram formats:

- Carbon
- Telegraph
- Sysdig StatsD
- Etsy StatsD (no tag support)

**Note:**
> This pipepline does not perform any aggregation on `statsd` datagrams, all metrics must be **aggregated on client side**

## APM

Data stream that collects custom metrics for system/service.

### Exported fields

 Field                           | Description                                                                                    | Type
---------------------------------|------------------------------------------------------------------------------------------------|------------------
 @timestamp                      | Event timestamp.                                                                               | date
 agent.id                        | Unique agent identifier.                                                                       | keyword
 agent.hostname                  | Name of the host where the agent is running.                                                   | keyword
 agent.name                      | Name of the agent.                                                                             | keyword
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
 host.name                       | Name of the host. It can contain what hostname returns on Unix systems, the fully qualified domain name, or a name specified by the user. The sender decides which value to use.                                                                                                      | keyword
 labels.*                        | Labels extracted from `statsd` datagram's tags.                                                | object
 service.name                    | Service that produced the logs.                                                                | keyword
 stats                           | Contains the stats extracted from `statsd` datagram.                                           | group
 stats.action                    | Stats action.                                                                                  | keyword
 stats.namespace                 | Stats namespace.                                                                               | keyword
 stats.section                   | Stats section.                                                                                 | keyword
 stats.target                    | Stats target.                                                                                  | keyword
 stats.value                     | Stats value.                                                                                   | long
