#!/bin/sh

set -e

if [ -n "$PUID" ]
then
    usermod --uid $PUID mosquitto
fi

if [ -n "$PGID" ]
then
    groupmod --gid $PGID mosquitto
fi

mkdir -p /mosquitto/{data,log,config}
mkdir -p /mosquitto/config/conf.d

chown -R mosquitto:mosquitto /mosquitto

if [ ! -e /mosquitto/config/mosquitto.conf ]
then
    tee /mosquitto/config/mosquitto.conf <<EOF
# Place your local configuration in /mqtt/config/conf.d/

pid_file /var/run/mosquitto.pid

persistence true
persistence_location /mosquitto/data/

user mosquitto

# Port to use for the default listener.
port 1883


log_dest file /mosquitto/log/mosquitto.log
log_dest stdout

include_dir /mosquitto/config/conf.d
EOF
fi


exec "$@"
