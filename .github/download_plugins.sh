#!/bin/sh

set -e
cd $(dirname $0)

down_plugin() {
  local file=../code/fluent-beats/plugins/flb-in_$2.so
  wget https://github.com/fluent-beats/fluent-bit-$1/releases/download/$3/flb-in_$2.so -q -O $file
}

down_plugin 'carbon' 'carbon' 'v1.0.0'
down_plugin 'docker-stats' 'docker_stats' 'v1.0.0'
down_plugin 'docker-info' 'docker_info' 'v1.0.0'
down_plugin 'docker-system' 'docker_system' 'v1.0.0'
down_plugin 'cpuinfo' 'cpuinfo' 'v1.0.1'
down_plugin 'diskinfo' 'diskinfo' 'v1.1.0'
down_plugin 'fsinfo' 'fsinfo' 'v1.0.0'
down_plugin 'meminfo' 'meminfo' 'v1.1.1'
down_plugin 'netinfo' 'netinfo' 'v1.0.1'
down_plugin 'load' 'load' 'v1.0.0'
