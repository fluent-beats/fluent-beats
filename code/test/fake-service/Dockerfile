FROM        alpine:latest

RUN         apk add --update --no-cache netcat-openbsd bash

COPY        ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]