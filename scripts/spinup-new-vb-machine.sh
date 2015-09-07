#!/usr/bin/env bash

docker-machine create \
               --driver virtualbox \
               --virtualbox-disk-size "40000" \
               --virtualbox-memory "512" \
               "$1"
