#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Please provide a name for the machine"
    exit 1
fi

docker-machine create \
               --driver virtualbox \
               --virtualbox-disk-size "40000" \
               --virtualbox-memory "512" \
               "$1"
