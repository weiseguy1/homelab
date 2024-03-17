FROM alpine:latest

RUN apk -U upgrade
RUN apk add bind

EXPOSE 53/tcp
EXPOSE 53/udp

USER bind:bind

CMD ["/usr/sbin/named", "-f"]
