#!/bin/sh

create_heartbeat_index_template() {
  host=$(cat ../../code/test/secrets/http_host.txt)
  pwd=$(cat ../../code/test/secrets/http_pwd.txt)

  curl --user elastic:$pwd \
  -X PUT "https://$host/_index_template/heartbeat-8-default" \
  -d "@heartbeat-index-template.json" \
  -H "Content-Type: application/json"
}

create_heartbeat_index_template
