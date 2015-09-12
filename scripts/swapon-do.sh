#!/usr/bin/env bash

# Setup a swapfile on one or more docker-machine digitalocean instances
#  by default digitalocean instances do not have swap enabled

# Adapted from:
# https://github.com/docker/machine/issues/829#issuecomment-98549179

command -v docker-machine &>/dev/null
if [ $? != 0 ]; then
    echo "This script requires the docker-machine command"
    exit 1
fi

command -v awk &>/dev/null
if [ $? != 0 ]; then
    echo "This script requires the awk command"
    exit 1
fi

machines="$*"
machines_all="$(docker-machine ls | grep digitalocean | awk '{print $1}')"
machines_all_flag=false

if [ -z "$machines" ]; then
    echo "Please provide one or more digitalocean machine names, or --all"
    exit 1
fi

for m in ${machines[@]}; do
    if [[ ( "$m" = "--all" ) || ( "$m" = "-a" ) ]]; then
        machines="$machines_all"
        machines_all_flag=true
        break
    fi
done

if [ $machines_all_flag = false ]; then
    for m in ${machines[@]}; do
        machine_match=false
        for m_a in ${machines_all[@]}; do
            if [ "$m_a" = "$m" ]; then
                machine_match=true
            fi
        done
        if [ $machine_match = false ]; then
            echo "No match for '$m' in the list of digitalocean machines"
            exit 1
        fi
        machine_match=false
    done
fi

if [[ ( $machines_all_flag = false ) && \
          ( $(echo $machines | tr ' ' '\n' | awk 'seen[$0]++{print "true"}' -)  != "" ) ]]; then
    echo "One or more machine names were given more than once:"
    echo ""
    echo $machines | tr ' ' '\n' | awk 'seen[$0]++ == 1' - | awk '{print "  " $0}' -
    echo ""
    exit 1
fi

echo "Will create swapfile (if none exists) on digitalocean machines:"
echo ""
echo $machines | tr ' ' '\n' | awk '{print "  " NR ". " $0}' -
echo ""
for m in ${machines[@]}; do
    printf "\x1B[01;33m$m\n\x1B[0m" && \
        docker-machine ssh $m -- "ls /swapfile &>/dev/null && free -htl" 2>/dev/null || \
            docker-machine ssh $m -- \
                           "fallocate -l 1G /swapfile && chmod 600 /swapfile && mkswap /swapfile && \
                echo -e '\n/swapfile none swap defaults 0 0' >> /etc/fstab && swapon -a && free -htl"
    echo ""
done
