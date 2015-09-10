#!/bin/bash

apt-get -y autoclean
apt-get -y clean
apt-get -y autoremove

rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
