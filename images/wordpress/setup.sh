#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export HOME=/root

/docker-build/support/config.sh
/docker-build/support/cleanup.sh
