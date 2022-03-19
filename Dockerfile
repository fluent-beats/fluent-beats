FROM fluent/fluent-bit:1.8.14

COPY /config/fluent-bit/plugins/in_carbon.so /fluent-bit/bin/in_carbon.so
COPY /config/fluent-bit/pipelines/*.* /fluent-bit/etc/
COPY /config/fluent-bit/fluent-bit.conf /fluent-bit/etc/

CMD ["/fluent-bit/bin/fluent-bit", "-c", "/fluent-bit/etc/fluent-bit.conf"]