#!/bin/sh

set -e
cd $(dirname $0)

get_input_plugin() {
  local file=fluent-beats/plugins/flb-in_$2.so
  if test -f "$file"; then
   echo "$file"
   return
  fi
  wget https://github.com/fluent-beats/fluent-bit-$1/releases/download/$3/flb-in_$2.so -q -O $file
}

download_plugins() {
  get_input_plugin 'carbon' 'carbon' 'v1.0.0'
  get_input_plugin 'docker-stats' 'docker_stats' 'v1.0.0'
  get_input_plugin 'docker-info' 'docker_info' 'v1.0.0'
  get_input_plugin 'docker-system' 'docker_system' 'v1.0.0'
  get_input_plugin 'meminfo' 'meminfo' 'v1.1.0'
  get_input_plugin 'load' 'load' 'v1.0.0'
}

run() {
  docker-compose -f test/docker-compose-test.yml up
}

echo " +++++++++++++++++++++++++++++++++++++++ "
echo " Make sure 'secrets' folder contains required files:"
echo "   http_host.txt -> ElasticSearch host"
echo "   http_pwd.txt  -> ElasticSearch password"
echo " +++++++++++++++++++++++++++++++++++++++ "

download_plugins && run