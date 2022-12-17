# Components

- pipeline-stats.conf
- stats-ecs.lua

# Metricsets

## CPU

The Docker cpu data stream collects runtime CPU metrics.

> `metricset.name: cpu`

### Exported fields

 Field                             | Description                                                                                        | Type             | Unit    | Metric Type
-----------------------------------|----------------------------------------------------------------------------------------------------|------------------|---------|------------
 @timestamp                        | Event timestamp.                                                                                   | date             |         |
 agent.id                          | Unique agent identifier.                                                                           | keyword          |         |
 agent.hostname                    | Name of the host where the agent is running.                                                       | keyword          |         |
 agent.name                        | Name of the agent.                                                                                 | keyword          |         |
 container.cpu.usage               | Total CPU usage normalized by the number of CPU cores.                                             | scaled_float     | percent | gauge
 container.id                      | Unique container id.                                                                               | keyword          |         |
 container.name                    | Container name.                                                                                    | keyword          |         |
 container.runtime                 | Runtime managing this container.                                                                   | keyword          |         |
 docker.cpu.kernel.norm.pct        | Percentage of time in kernel space normalized by the number of CPU cores.                          | scaled_float     | percent | gauge
 docker.cpu.kernel.pct             | Percentage of time in kernel space.                                                                | scaled_float     | percent | gauge
 docker.cpu.kernel.ticks           | CPU ticks in kernel space.                                                                         | long             |         | counter
 docker.cpu.dstats                 | Contains metrics calculated as shown by on Docker `stats` command.                                 | object           |         |
 docker.cpu.dstats.usage           | CPU system ticks, alias for `docker.cpu.system.ticks`.                                             | long             |         | counter
 docker.cpu.dstats.delta           | Amount of CPU ticks consumed by the container since previous read.                                 | long             |         | counter
 docker.cpu.dstats.cpus            | Number of CPU cores                                                                                | long             |         | counter
 docker.cpu.dstats.system.delta    | Amount of CPU ticks consumed by the system since previous read.                                    | long             |         | counter
 docker.cpu.dstats.percent_usage   | Percentage CPU consumed by the container.                                                          | scaled_float     | percent | gauge
 docker.cpu.system.norm.pct        | Percentage of total CPU time in the system normalized by the number of CPU cores.                  | scaled_float     | percent | gauge
 docker.cpu.system.pct             | Percentage of total CPU time in the system.                                                        | scaled_float     | percent | gauge
 docker.cpu.system.ticks           | CPU system ticks.                                                                                  | long             |         | counter
 docker.cpu.total.norm.pct         | Total CPU usage normalized by the number of CPU cores.                                             | scaled_float     | percent | gauge
 docker.cpu.total.pct              | Total CPU usage.                                                                                   | scaled_float     | percent | gauge
 docker.cpu.user.norm.pct          | Percentage of time in user space normalized by the number of CPU cores.                            | scaled_float     | percent | gauge
 docker.cpu.user.pct               | Percentage of time in user space.                                                                  | scaled_float     | percent | gauge
 docker.cpu.user.ticks             | CPU ticks in user space.                                                                           | long             |         | counter
 ecs.version                       | ECS version this event conforms to. ecs.version is a required field and must exist in all events. When querying across multiple indices -- which may conform to slightly different ECS versions -- this field lets integrations adjust to the schema version of the events.                 | keyword          |         |
 event.dataset                     | Event dataset                                                                                      | constant_keyword |         |
 event.kind                        | Event kind                                                                                         | constant_keyword |         |
 event.module                      | Event module                                                                                       | constant_keyword |         |
 service.address                   | Address where data about this service was collected from. This should be a URI, network address (ipv4:port or [ipv6]:port) or a resource path (sockets).                                                                                                                             | keyword          |         |
 service.type                      | The type of the service data is collected from. The type can be used to group and correlate logs and metrics from one service type. Example: If logs or metrics are collected from Elasticsearch, service.type would be elasticsearch.                                                         | keyword          |         |

---

## Diskio

The Docker diskio data stream collects disk I/O metrics.
> `metricset.name: disk`

### Exported fields

 Field                              | Description                                                                                        | Type             | Unit    | Metric Type
------------------------------------|----------------------------------------------------------------------------------------------------|------------------|---------|------------
 @timestamp                         | Event timestamp.                                                                                   | date             |         |
 agent.id                           | Unique agent identifier.                                                                           | keyword          |         |
 agent.hostname                     | Name of the host where the agent is running.                                                       | keyword          |         |
 agent.name                         | Name of the agent.                                                                                 | keyword          |         |
 container.disk.read.bytes          | Bytes read during the life of the container                                                        | long             | byte    | counter
 container.disk.write.bytes         | Bytes written during the life of the container                                                     | long             | byte    | counter
 container.id                       | Unique container id.                                                                               | keyword          |         |
 container.name                     | Container name.                                                                                    | keyword          |         |
 container.runtime                  | Runtime managing this container.                                                                   | keyword          |         |
 docker.diskio.read.bytes           | Bytes read during the life of the container                                                        | long             | byte    | counter
 docker.diskio.read.ops             | Number of reads during the life of the container                                                   | long             |         |
 docker.diskio.read.queued          | Total number of queued requests                                                                    | long             |         | gauge
 docker.diskio.read.service_time    | Total time to service IO requests, in nanoseconds                                                  | long             |         | counter
 docker.diskio.read.wait_time       | Total time requests spent waiting in queues for service, in nanoseconds                            | long             |         | counter
 docker.diskio.summary.bytes        | Bytes read and written during the life of the container                                            | long             | byte    | counter
 docker.diskio.summary.ops          | Number of I/O operations during the life of the container                                          | long             |         | counter
 docker.diskio.summary.queued       | Total number of queued requests                                                                    | long             |         | counter
 docker.diskio.summary.service_time | Total time to service IO requests, in nanoseconds                                                  | long             |         | counter
 docker.diskio.summary.wait_time    | Total time requests spent waiting in queues for service, in nanoseconds                            | long             |         | counter
 docker.diskio.write.bytes          | Bytes written during the life of the container                                                     | long             | byte    | counter
 docker.diskio.write.ops            | Number of writes during the life of the container                                                  | long             |         | counter
 docker.diskio.write.queued         | Total number of queued requests                                                                    | long             |         | counter
 docker.diskio.write.service_time   | Total time to service IO requests, in nanoseconds                                                  | long             |         | counter
 docker.diskio.write.wait_time      | Total time requests spent waiting in queues for service, in nanoseconds                            | long             |         | counter
 ecs.version                        | ECS version this event conforms to. ecs.version is a required field and must exist in all events. When querying across multiple indices -- which may conform to slightly different ECS versions -- this field lets integrations adjust to the schema version of the events.                  | keyword          |         |
 event.dataset                      | Event dataset                                                                                      | constant_keyword |         |
 event.kind                         | Event kind                                                                                         | constant_keyword |         |
 event.module                       | Event module                                                                                       | constant_keyword |         |
 service.address                    | Address where data about this service was collected from. This should be a URI, network address (ipv4:port or [ipv6]:port) or a resource path (sockets).                                                                                                                              | keyword          |         |
 service.type                       | The type of the service data is collected from. The type can be used to group and correlate logs and metrics from one service type. Example: If logs or metrics are collected from Elasticsearch, service.type would be elasticsearch.                                                       | keyword          |         |

---

## Memory

The Docker memory data stream collects memory metrics from docker.

> `metricset.name: memory`

### Exported fields

 Field                                     | Description                                                                                        | Type             | Unit    | Metric Type
-------------------------------------------|----------------------------------------------------------------------------------------------------|------------------|---------|------------
 @timestamp                                | Event timestamp.                                                                                   | date             |         |
 agent.id                                  | Unique agent identifier.                                                                           | keyword          |         |
 agent.hostname                            | Name of the host where the agent is running.                                                       | keyword          |         |
 agent.name                                | Name of the agent.                                                                                 | keyword          |         |
 container.id                              | Unique container id.                                                                               | keyword          |         |
 container.memory.usage                    | Memory usage percentage.                                                                           | scaled_float     | percent | gauge
 container.name                            | Container name.                                                                                    | keyword          |         |
 container.runtime                         | Runtime managing this container.                                                                   | keyword          |         |
 docker.memory.commit.peak                 | Peak committed bytes on Windows                                                                    | long             | byte    | gauge
 docker.memory.commit.total                | Total bytes on Windows                                                                             | long             | byte    | counter
 docker.memory.dstats                      | Contains metrics calculated as shown by on Docker `stats` command.                                 | object           |         |
 docker.memory.dstats.available            | Memory limit, alias for `docker.memory.limit`.                                                     | long             | byte    | counter
 docker.memory.dstats.used                 | Amount of memory consumed by the container.                                                        | long             |         | counter
 docker.memory.dstats.percent_usage        | Percentage memory consumed by the container.                                                       | scaled_float     | percent | gauge
 docker.memory.fail.count                  | Fail counter.                                                                                      | scaled_float     |         | counter
 docker.memory.limit                       | Memory limit.                                                                                      | long             | byte    | gauge
 docker.memory.private_working_set.total   | Private working sets on Windows                                                                    | long             | byte    | gauge
 docker.memory.rss.pct                     | Memory resident set size percentage.                                                               | scaled_float     | percent | gauge
 docker.memory.rss.total                   | Total memory resident set size.                                                                    | long             | byte    | gauge
 docker.memory.stats.*                     | Raw memory stats from the cgroups memory.stat interface                                            | object           |         |
 docker.memory.usage.max                   | Max memory usage.                                                                                  | long             | byte    | gauge
 docker.memory.usage.pct                   | Memory usage percentage.                                                                           | scaled_float     | percent | gauge
 docker.memory.usage.total                 | Total memory usage.                                                                                | long             | byte    | gauge
 ecs.version                               | ECS version this event conforms to. ecs.version is a required field and must exist in all events. When querying across multiple indices -- which may conform to slightly different ECS versions -- this field lets integrations adjust to the schema version of the events.               | keyword          |         |
 event.dataset                             | Event dataset                                                                                      | constant_keyword |         |
 event.kind                                | Event kind                                                                                         | constant_keyword |         |
 event.module                              | Event module                                                                                       | constant_keyword |         |
 service.address                           | Address where data about this service was collected from. This should be a URI, network address (ipv4:port or [ipv6]:port) or a resource path (sockets).                                                                                                                                     | keyword          |         |
 service.type                              | The type of the service data is collected from. The type can be used to group and correlate logs and metrics from one service type. Example: If logs or metrics are collected from Elasticsearch, service.type would be elasticsearch.                                                         | keyword          |         |

---

## Network

The Docker network data stream collects network metrics.

> `metricset.name: network`

### Exported fields

 Field                              | Description                                                                                       | Type             | Metric Type
------------------------------------|---------------------------------------------------------------------------------------------------|------------------|------------
 @timestamp                         | Event timestamp.                                                                                  | date             |
 agent.id                           | Unique agent identifier.                                                                          | keyword          |
 agent.hostname                     | Name of the host where the agent is running.                                                      | keyword          |
 agent.name                         | Name of the agent.                                                                                | keyword          |
 container.id                       | Unique container id.                                                                              | keyword          |
 container.name                     | Container name.                                                                                   | keyword          |
 container.network.egress.bytes     | Total number of outgoing bytes.                                                                   | long             | counter
 container.network.ingress.bytes    | Total number of incoming bytes.                                                                   | long             | counter
 container.runtime                  | Runtime managing this container.                                                                  | keyword          |
 docker.network.in.bytes            | Total number of incoming bytes.                                                                   | long             | counter
 docker.network.in.dropped          | Total number of dropped incoming packets.                                                         | long             | counter
 docker.network.in.errors           | Total errors on incoming packets.                                                                 | long             | counter
 docker.network.in.packets          | Total number of incoming packets.                                                                 | long             | counter
 docker.network.interface           | Network interface name.                                                                           | keyword          |
 docker.network.out.bytes           | Total number of outgoing bytes.                                                                   | long             | counter
 docker.network.out.dropped         | Total number of dropped outgoing packets.                                                         | long             | counter
 docker.network.out.errors          | Total errors on outgoing packets.                                                                 | long             | counter
 docker.network.out.packets         | Total number of outgoing packets.                                                                 | long             | counter
 ecs.version                        | ECS version this event conforms to. ecs.version is a required field and must exist in all events. When querying across multiple indices -- which may conform to slightly different ECS versions -- this field lets integrations adjust to the schema version of the events.                 | keyword          |
 event.dataset                      | Event dataset                                                                                     | constant_keyword |
 event.kind                         | Event kind                                                                                        | constant_keyword |
 event.module                       | Event module                                                                                      | constant_keyword |
 service.address                    | Address where data about this service was collected from. This should be a URI, network address (ipv4:port or [ipv6]:port) or a resource path (sockets).                                                                                                                             | keyword          |
 service.type                       | The type of the service data is collected from. The type can be used to group and correlate logs and metrics from one service type. Example: If logs or metrics are collected from Elasticsearch, service.type would be elasticsearch.                                                      | keyword          |


