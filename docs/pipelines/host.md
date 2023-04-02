# Components

- pipeline-host.conf
- host-ecs.lua

# Metricsets

## CPU

> `metricset.name: host_cpu`

### Exported fields

 Field                             | Description                                                                                        | Type             | Unit    | Metric Type
-----------------------------------|----------------------------------------------------------------------------------------------------|------------------|---------|------------
 @timestamp                        | Event timestamp.                                                                                   | date             |         |
 agent.id                          | Unique agent identifier.                                                                           | keyword          |         |
 agent.hostname                    | Name of the host where the agent is running.                                                       | keyword          |         |
 agent.name                        | Name of the agent.                                                                                 | keyword          |         |
 data_stream.dataset               | Data stream dataset.                                                                               | constant_keyword |         |
 data_stream.namespace             | Data stream namespace.                                                                             | constant_keyword |         |
 data_stream.type                  | Data stream type.                                                                                  | constant_keyword |         |
 ecs.version                       | ECS version this event conforms to. ecs.version is a required field and must exist in all events. When querying across multiple indices -- which may conform to slightly different ECS versions -- this field lets integrations adjust to the schema version of the events.                 | keyword          |         |
 event.dataset                     | Event dataset.                                                                                     | constant_keyword |         |
 event.kind                        | Event kind.                                                                                        | constant_keyword |         |
 event.module                      | Event module.                                                                                      | constant_keyword |         |
 host                              | A host is defined as a general computing instance. ECS host.* fields should be populated with details about the host on which the event happened, or from which the measurement was taken. Host types include hardware, virtual machines and Docker containers                              | group            |         |
 host.hostname                     | Hostname of the host. It normally contains what the hostname command returns on the hostmachine.                                                                                                                           | keyword          |         |
 host.ip                           | Host ip addresses.                                                                                 | ip               |         |
 host.name                         | Name of the host. It can contain what hostname returns on Unix systems, the fully qualified domain name, or a name specified by the user. The sender decides which value to use.                                                                                                            | keyword          |         |
 service.address                   | Address where data about this service was collected from. This should be a URI, network address (ipv4:port or [ipv6]:port) or a resource path (sockets).                                                                                                                             | keyword          |         |
 service.type                      | The type of the service data is collected from. The type can be used to group and correlate logs and metrics from one service type. Example: If logs or metrics are collected from Elasticsearch, service.type would be elasticsearch.                                                         | keyword          |         |
 system.cpu.cores                  | The number of CPU cores present on the host                                                        | long             |         |
 system.cpu.system.pct             | The percentage of CPU time spent in kernel space. On multi-core systems, values can be greater than 100%.                                                                                                                                  | scaled_float     |         |
 system.cpu.system.norm.pct        | The percentage of CPU time spent in kernel space divided by the number of cores                    | scaled_float     | percent | gauge
 system.cpu.total.pct              | The percentage of CPU time spent in states other than Idle and IOWait. On multi-core systems, values can be greater than 100%.                                                                                                                                  | scaled_float     |         |
 system.cpu.total.norm.pct         | The percentage of CPU time spent in states other than Idle and IOWait divided by the number of cores
                                                                                                                                        | scaled_float     | percent | gauge
 system.cpu.user.pct               | The percentage of CPU time spent in user space. On multi-core systems, values can be greater than 100%.                                                                                                                                  | scaled_float     |         |
 system.cpu.user.norm.pct          | The percentage of CPU time spent in user space divided by the number of cores                      | scaled_float     | percent | gauge
## Memory

> `metricset.name: host_memory`

### Exported fields

 Field                             | Description                                                                                        | Type             | Unit    | Metric Type
-----------------------------------|----------------------------------------------------------------------------------------------------|------------------|---------|------------
 @timestamp                        | Event timestamp.                                                                                   | date             |         |
 agent.id                          | Unique agent identifier.                                                                           | keyword          |         |
 agent.hostname                    | Name of the host where the agent is running.                                                       | keyword          |         |
 agent.name                        | Name of the agent.                                                                                 | keyword          |         |
 data_stream.dataset               | Data stream dataset.                                                                               | constant_keyword |         |
 data_stream.namespace             | Data stream namespace.                                                                             | constant_keyword |         |
 data_stream.type                  | Data stream type.                                                                                  | constant_keyword |         |
 ecs.version                       | ECS version this event conforms to. ecs.version is a required field and must exist in all events. When querying across multiple indices -- which may conform to slightly different ECS versions -- this field lets integrations adjust to the schema version of the events.                 | keyword          |         |
 event.dataset                     | Event dataset.                                                                                     | constant_keyword |         |
 event.kind                        | Event kind.                                                                                        | constant_keyword |         |
 event.module                      | Event module.                                                                                      | constant_keyword |         |
 host                              | A host is defined as a general computing instance. ECS host.* fields should be populated with details about the host on which the event happened, or from which the measurement was taken. Host types include hardware, virtual machines and Docker containers                              | group            |         |
 host.hostname                     | Hostname of the host. It normally contains what the hostname command returns on the hostmachine.                                                                                                                           | keyword          |         |
 host.ip                           | Host ip addresses.                                                                                 | ip               |         |
 host.name                         | Name of the host. It can contain what hostname returns on Unix systems, the fully qualified domain name, or a name specified by the user. The sender decides which value to use.                                                                                                            | keyword          |         |
 service.address                   | Address where data about this service was collected from. This should be a URI, network address (ipv4:port or [ipv6]:port) or a resource path (sockets).                                                                                                                             | keyword          |         |
 service.type                      | The type of the service data is collected from. The type can be used to group and correlate logs and metrics from one service type. Example: If logs or metrics are collected from Elasticsearch, service.type would be elasticsearch.                                                         | keyword          |         |
 system.memory.free                | The total amount of free memory in bytes. This value does not include memory consumed by system caches and buffers (see system.memory.actual.free).                                                                                                                                 | long             | bytes   | gauge
 system.memory.actual.free         | Actual free memory in bytes.                                                                       | long             | bytes   | gauge
 system.memory.actual.used.bytes   | Actual used memory in bytes. It represents the difference between the total and the available memory.                                                                                                                                | long             | bytes   | gauge
 system.memory.actual.used.pct     | The percentage of actual used memory.                                                              | scaled_float     | percent | gauge
 system.memory.cached              | Total Cached memory on system.                                                                     | long             | bytes   | gauge
 system.memory.total               | Total memory.                                                                                      | long             | bytes   | gauge
 system.memory.used.bytes          | Used memory.                                                                                       | long             | bytes   | gauge
 system.memory.used.pct            | The percentage of used memory.                                                                     | scaled_float     | percent | gauge

## Network

> `metricset.name: host_network`

### Exported fields

 Field                             | Description                                                                                        | Type             | Unit    | Metric Type
-----------------------------------|----------------------------------------------------------------------------------------------------|------------------|---------|------------
 @timestamp                        | Event timestamp.                                                                                   | date             |         |
 agent.id                          | Unique agent identifier.                                                                           | keyword          |         |
 agent.hostname                    | Name of the host where the agent is running.                                                       | keyword          |         |
 agent.name                        | Name of the agent.                                                                                 | keyword          |         |
 data_stream.dataset               | Data stream dataset.                                                                               | constant_keyword |         |
 data_stream.namespace             | Data stream namespace.                                                                             | constant_keyword |         |
 data_stream.type                  | Data stream type.                                                                                  | constant_keyword |         |
 ecs.version                       | ECS version this event conforms to. ecs.version is a required field and must exist in all events. When querying across multiple indices -- which may conform to slightly different ECS versions -- this field lets integrations adjust to the schema version of the events.                 | keyword          |         |
 event.dataset                     | Event dataset.                                                                                     | constant_keyword |         |
 event.kind                        | Event kind.                                                                                        | constant_keyword |         |
 event.module                      | Event module.                                                                                      | constant_keyword |         |
 host                              | A host is defined as a general computing instance. ECS host.* fields should be populated with details about the host on which the event happened, or from which the measurement was taken. Host types include hardware, virtual machines and Docker containers                              | group            |         |
 host.hostname                     | Hostname of the host. It normally contains what the hostname command returns on the hostmachine.                                                                                                                           | keyword          |         |
 host.ip                           | Host ip addresses.                                                                                 | ip               |         |
 host.name                         | Name of the host. It can contain what hostname returns on Unix systems, the fully qualified domain name, or a name specified by the user. The sender decides which value to use.                                                                                                            | keyword          |         |
 host.network.egress.bytes         | The number of bytes sent out on all network interfaces by the host.                                | keyword          | bytes   | gauge
 host.network.ingress.bytes        | The number of bytes received out on all network interfaces by the host.                            | keyword          | bytes   | gauge
 service.address                   | Address where data about this service was collected from. This should be a URI, network address (ipv4:port or [ipv6]:port) or a resource path (sockets).                                                                                                                             | keyword          |         |
 service.type                      | The type of the service data is collected from. The type can be used to group and correlate logs and metrics from one service type. Example: If logs or metrics are collected from Elasticsearch, service.type would be elasticsearch.                                                         | keyword          |         |
 system.network.in.bytes           | The number of bytes received.                                                                      | long             | bytes   | gauge
 system.network.out.bytes          | The number of bytes sent.                                                                          | long             | bytes   | gauge

## Load

 > `metricset.name: host_load`

### Exported fields

 Field                             | Description                                                                                        | Type             | Unit    | Metric Type
-----------------------------------|----------------------------------------------------------------------------------------------------|------------------|---------|------------
 @timestamp                        | Event timestamp.                                                                                   | date             |         |
 agent.id                          | Unique agent identifier.                                                                           | keyword          |         |
 agent.hostname                    | Name of the host where the agent is running.                                                       | keyword          |         |
 agent.name                        | Name of the agent.                                                                                 | keyword          |         |
 data_stream.dataset               | Data stream dataset.                                                                               | constant_keyword |         |
 data_stream.namespace             | Data stream namespace.                                                                             | constant_keyword |         |
 data_stream.type                  | Data stream type.                                                                                  | constant_keyword |         |
 ecs.version                       | ECS version this event conforms to. ecs.version is a required field and must exist in all events. When querying across multiple indices -- which may conform to slightly different ECS versions -- this field lets integrations adjust to the schema version of the events.                 | keyword          |         |
 event.dataset                     | Event dataset.                                                                                     | constant_keyword |         |
 event.kind                        | Event kind.                                                                                        | constant_keyword |         |
 event.module                      | Event module.                                                                                      | constant_keyword |         |
 host                              | A host is defined as a general computing instance. ECS host.* fields should be populated with details about the host on which the event happened, or from which the measurement was taken. Host types include hardware, virtual machines and Docker containers                              | group            |         |
 host.hostname                     | Hostname of the host. It normally contains what the hostname command returns on the hostmachine.                                                                                                                           | keyword          |         |
 host.ip                           | Host ip addresses.                                                                                 | ip               |         |
 host.name                         | Name of the host. It can contain what hostname returns on Unix systems, the fully qualified domain name, or a name specified by the user. The sender decides which value to use.                                                                                                            | keyword          |         |
 service.address                   | Address where data about this service was collected from. This should be a URI, network address (ipv4:port or [ipv6]:port) or a resource path (sockets).                                                                                                                             | keyword          |         |
 service.type                      | The type of the service data is collected from. The type can be used to group and correlate logs and metrics from one service type. Example: If logs or metrics are collected from Elasticsearch, service.type would be elasticsearch.                                                         | keyword          |         |
 system.memory.free                | The total amount of free memory in bytes. This value does not include memory consumed by system caches and buffers (see system.memory.actual.free).                                                                                         | long     | bytes | gauge
 system.load.1                     | Load average for the last minute.                                                                  | scaled_float     | percent | gauge
 system.load.5                     | Load average for the 5 minutes.                                                                    | scaled_float     | percent | gauge
 system.load.15                    | Load average for the 15 minutes.                                                                   | scaled_float     | percent | gauge
 system.load.cores                 | The number of CPU cores present on the host.                                                       | long             |         |
 system.load.norm.1                | Load for the last minute divided by the number of cores.                                           | scaled_float     | percent | gauge
 system.load.norm.5                | Load for the 5 minutes divided by the number of cores.                                             | scaled_float     | percent | gauge
 system.load.norm.15               | Load for the 15 minutes divided by the number of cores.                                            | scaled_float     | percent | gauge
