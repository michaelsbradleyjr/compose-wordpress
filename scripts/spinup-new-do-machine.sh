#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Please provide a name for the machine"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Please provide a Digital Ocean API token"
    exit 1
fi

docker-machine create \
               --driver digitalocean \
               --digitalocean-access-token "$2" \
               --digitalocean-region "nyc3" \
               --digitalocean-size "512mb" \
               "$1"
