#!/bin/bash

# env
source ./set-env.sh

# Source library of functions
source ../lib/qb.shlib
source ../lib/qb.web-api.shlib

echo "=========== raw ==========="
get_torrents && echo "$qbt_torrents"

echo "=========== the list of torrent hash ==========="
echo "$qbt_torrents" | $jq_executable ".[].hash" -r
