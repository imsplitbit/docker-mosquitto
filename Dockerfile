FROM debian:buster

MAINTAINER Daniel Salinas <imsplitbit@gmail.com>

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="BSD 3-Clause" \
    org.label-schema.name="docker-mosquitto" \
    org.label-schema.url="https://hub.docker.com/r/imsplitbit/mosquitto/" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/imsplitbit/docker-mosquitto"

RUN apt-get update && apt-get install -y sudo wget gnupg && \
    wget -q -O - https://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | gpg --import && \
    gpg -a --export 8277CCB49EC5B595F2D2C71361611AE430993623 | apt-key add - && \
    wget -q -O /etc/apt/sources.list.d/mosquitto-buster.list https://repo.mosquitto.org/debian/mosquitto-buster.list && \
    apt-get update && apt-get install -y mosquitto mosquitto-clients && \
    adduser --system --disabled-password --disabled-login mosquitto

RUN mkdir -p /mosquitto/config /mosquitto/data /mosquitto/log
COPY config /mosquitto/config
VOLUME ["/mosquitto/config", "/mosquitto/data", "/mosquitto/log"]


EXPOSE 1883 9001

ADD docker-entrypoint.sh /usr/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/sbin/mosquitto", "-c", "/mosquitto/config/mosquitto.conf"]
