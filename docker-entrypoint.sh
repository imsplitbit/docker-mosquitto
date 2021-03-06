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

if [ ! -d /mosquitto ]
then
    mkdir -p /mosquitto/{data,log,config}
    chowm mosquitto:mosquitto /mosquitto/data
    chown mosquitto:mosquitto /mosquitto/log
    chown mosquitto:mosquitto /mosquitto/config
fi

if [ ! -d /mosquitto/config/conf.d ]
then
    mkdir -p /mosquitto/config/conf.d
    chown mosquitto:mosquitto /mosquitto/config/conf.d
fi

# chown -R mosquitto:mosquitto /mosquitto

if [ ! -e /mosquitto/config/mosquitto.conf ]
then
    sudo -u mosquitto -g mosquitto tee /mosquitto/config/mosquitto.conf <<EOF
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
