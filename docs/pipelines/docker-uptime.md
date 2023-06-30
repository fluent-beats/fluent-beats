# Components

- pipeline-info.conf
- info-ecs.lua

# Target Data Stream

**synthetics-tcp-default**

# Configurations

`Fluent-Beats` uses container inspections information from [Docker Container Inspect](https://docs.docker.com/engine/api/v1.41/#operation/ContainerInspect), to create records compatible to [Heartbeat TCP Monitors](https://www.elastic.co/guide/en/beats/heartbeat/current/monitor-tcp-options.html) in order to track running and stopped containers over time.

To access the heartbeats from `Kibana Uptime Monitors`, `Fluent-Beats` relies on the pre-defined datastream named `synthetics-tcp-default`.

# Caveats

The translation from **Container running state** to **TCP Hearbeat** has some caveats, because some TCP monitor information are not available by default.

These caveats are exclusive for the `url` (tcp://IP:PORT) registered into **TCP Hearbeat**, however **these records are still realiable** and can be used to monitor the services uptime for most scenarios.

## 1- TCP Monitor Port

### Limitation:

Some containers may not define a **Healtchcheck** strategy, but even using Docker **Healtchcheck** definition, we can't assert which port is used to track container's health. So how do we set port to ours TCP heartbeats?

### Solution

To solve that `Fluent-Beats` uses a default port, 80 to register the related **TCP Heartbeats** for a given container.

### Caveat

All `Fluent-Beats` **TCP Heartbeats** will be registered as pings to port 80, but are actually not.

## 2- TCP Monitor IP

### Limitation
Many times the container **NetworkSettings** entry doesn't provide an IP address to use. So how do we set an IP address to ours TCP heartbeats?

### Solution

In this scenario `Fluent-Beats` will fallback to host IP address.

### Caveat

For different containers, may exist **TCP Heartbeats** using the same IP/port values.