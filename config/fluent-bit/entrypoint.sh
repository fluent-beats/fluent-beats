#!/bin/bash

set -e

# https://medium.com/@adrian.gheorghe.dev/using-docker-secrets-in-your-environment-variables-7a0609659aab
# https://www.rockyourcode.com/using-docker-secrets-with-docker-compose/
# usage: file_env VAR [DEFAULT]
file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		mysql_error "Both $var and $fileVar are set (but are exclusive)"
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

setup_env() {
	# Initialize values that might be stored in a file
	#file_env 'ES_CLOUD_ID'
	#file_env 'ES_CLOUD_AUTH_FILE'
}

setup_env "$@"