#!/bin/bash

random_apm() {
   pick=$(shuf -i 0-4 -n 1)
   metric=$(shuf -i 100-1000 -n 1)

   case "$pick" in
      "1") value="database.query.users.select-by;env=prod;service=$SERVICE_NAME:$metric|ms|@0.1"
      ;;
      "2") value="memory.java.heap.used;env=prod;service=$SERVICE_NAME:$metric|g"
      ;;
      "3") value="click;env=prod;service=$SERVICE_NAME:$metric|c|@0.1"
      ;;
      "4") value="http.sessions.users.active;env=prod;service=$SERVICE_NAME:$metric|c"
      ;;
   esac

   nc -w0 -q0 -u fluent-beats 8125 <<< "$value"
}

random_log() {
   pick=$(shuf -i 0-4 -n 1)
   ts=`date -Iseconds`

   case "$pick" in
      "1") echo "{\"@timestamp\": \"$ts\", \"level\": \"ERROR\", \"message\": \"something happened in this execution.\"}"
      ;;
      "2") echo "{\"@timestamp\": \"$ts\", \"level\": \"INFO\", \"message\": \"takes the value and converts it to string.\"}"
      ;;
      "3") echo "{\"@timestamp\": \"$ts\", \"level\": \"WARN\", \"message\": \"variable not in use.\"}"
      ;;
      "4") echo "{\"@timestamp\": \"$ts\", \"level\": \"DEBUG\", \"message\": \"first loop completed.\"}"
      ;;
   esac
}

random_sleep() {
   waitTime=$(shuf -i 1-5 -n 1)
   sleep $waitTime &
   wait $!
}

main() {
   while [ 1 ]
   do
      random_sleep
      random_log
      random_apm
   done
}

main