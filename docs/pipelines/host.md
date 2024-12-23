# Components

- pipeline-host.conf
- host-ecs.lua

# Target Data Stream

**metrics-host.stats-default**

# Metricsets

## CPU

Host data stream that collects CPU metrics.

> `metricset.name: system_cpu`

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
 system.cpu.cores                  | The number of CPU cores present on the host                                                        | long             |         |
 system.cpu.system.pct             | The percentage of CPU time spent in kernel space. On multi-core systems, values can be greater than 100%.                                                                                                                                  | scaled_float     |         |
 system.cpu.system.norm.pct        | The percentage of CPU time spent in kernel space divided by the number of cores                    | scaled_float     | percent | gauge
 system.cpu.total.pct              | The percentage of CPU time spent in states other than Idle and IOWait. On multi-core systems, values can be greater than 100%.                                                                                                                                  | scaled_float     |         |
 system.cpu.total.norm.pct         | The percentage of CPU time spent in states other than Idle and IOWait divided by the number of cores| scaled_float     | percent | gauge
 system.cpu.user.pct               | The percentage of CPU time spent in user space. On multi-core systems, values can be greater than 100%.                                                                                                                                  | scaled_float     |         |
 system.cpu.user.norm.pct          | The percentage of CPU time spent in user space divided by the number of cores                      | scaled_float     | percent | gauge

---

## Disk IO

Host data stream that collects disk I/O metrics.

> `metricset.name: system_disk`

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
 system.diskio.read.bytes          | The total number of bytes read successfully. On Linux this is the number of sectors read multiplied by an assumed sector size of 512.                                                                                                                                   | long             | bytes   |
 system.diskio.read.count          | The total number of reads completed successfully.                                                  | long             |         |
 system.diskio.read.time           | The total number of milliseconds spent by all reads.                                               | long             |         |
 system.diskio.write.bytes         | The total number of bytes written successfully. On Linux this is the number of sectors written multiplied by an assumed sector size of 512                                                                                                                                    | long             | bytes   |
 system.diskio.write.count         | The total number of writes completed successfully.                                                 | long             |         |
 system.diskio.write.time          | The total number of milliseconds spent by all writes.                                              | long             |         |
---

## File System

Host data stream that collects memory metrics.

> `metricset.name: system_filesystem`

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
 system.filesystem.available       | The disk space available to an unprivileged user in bytes.                                         | long             | bytes   | gauge
 system.filesystem.files           | Total number of inodes on the system, which will be a combination of files, folders, symlinks, and devices.                                                                                                                               | long             | bytes   | gauge
 system.filesystem.free            | The disk space available in bytes.                                                                 | long             | bytes   | gauge
 system.filesystem.free_files      | The number of free inodes in the file system.                                                      | long             | bytes   | gauge
 system.filesystem.mount_point     | The mounting point.                                                                                | keyword          |         |
 system.filesystem.total           | The total disk space in bytes.                                                                     | long             | bytes   | gauge
 system.filesystem.used.bytes      | The used disk space in bytes.                                                                      | long             | bytes   | gauge
 system.filesystem.used.pct        | The percentage of used disk space.                                                                 | scaled_float     | percent | gauge


---

## Memory

Host data stream that collects memory metrics.

> `metricset.name: system_memory`

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
 system.memory.free                | The total amount of free memory in bytes. This value does not include memory consumed by system caches and buffers (see system.memory.actual.free).                                                                                                                                 | long             | bytes   | gauge
 system.memory.actual.free         | Actual free memory in bytes.                                                                       | long             | bytes   | gauge
 system.memory.actual.used.bytes   | Actual used memory in bytes. It represents the difference between the total and the available memory.                                                                                                                                | long             | bytes   | gauge
 system.memory.actual.used.pct     | The percentage of actual used memory.                                                              | scaled_float     | percent | gauge
 system.memory.cached              | Total Cached memory on system.                                                                     | long             | bytes   | gauge
 system.memory.total               | Total memory.                                                                                      | long             | bytes   | gauge
 system.memory.used.bytes          | Used memory.                                                                                       | long             | bytes   | gauge
 system.memory.used.pct            | The percentage of used memory.                                                                     | scaled_float     | percent | gauge

---

## Network

Host data stream that collects network metrics.

> `metricset.name: system_network`

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
 system.network.in.bytes           | The number of bytes received.                                                                      | long             | bytes   | gauge
 system.network.out.bytes          | The number of bytes sent.                                                                          | long             | bytes   | gauge

---

## Load

Host data stream that collects system load metrics.

 > `metricset.name: system_load`

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
 system.load.1                     | Load average for the last minute.                                                                  | scaled_float     | percent | gauge
 system.load.5                     | Load average for the 5 minutes.                                                                    | scaled_float     | percent | gauge
 system.load.15                    | Load average for the 15 minutes.                                                                   | scaled_float     | percent | gauge
 system.load.cores                 | The number of CPU cores present on the host.                                                       | long             |         |
 system.load.norm.1                | Load for the last minute divided by the number of cores.                                           | scaled_float     | percent | gauge
 system.load.norm.5                | Load for the 5 minutes divided by the number of cores.                                             | scaled_float     | percent | gauge
 system.load.norm.15               | Load for the 15 minutes divided by the number of cores.                                            | scaled_float     | percent | gauge
