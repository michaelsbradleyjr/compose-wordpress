#!/usr/bin/env bash

docker-machine create \
               --driver digitalocean \
               --digitalocean-access-token "$2" \
               --digitalocean-region "nyc3" \
               --digitalocean-size "512mb" \
               "$1"
