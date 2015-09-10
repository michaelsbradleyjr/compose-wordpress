#!/usr/bin/env bash

command -v docker-machine &>/dev/null
if [ $? != 0 ]; then
    echo "This script requires the docker-machine command"
    exit 1
fi

if [ -z "$1" ]; then
    echo "Please provide a name for the machine"
    exit 1
fi

docker-machine create \
               --driver virtualbox \
               --virtualbox-disk-size "40000" \
               --virtualbox-memory "512" \
               "$1"
