#!/usr/bin/env bash

for i in $(docker-machine ls | grep digitalocean | awk '{print $1}'); \
    do printf "\x1B[01;33m\n$i\n\x1B[0m" && docker-machine ssh $i ls /swapfile || \
                docker-machine ssh $i -- \
                               "fallocate -l 1G /swapfile && chmod 600 /swapfile && mkswap /swapfile && \
                echo -e '\n/swapfile none swap defaults 0 0' >> /etc/fstab && swapon -a && free -htl"; done
