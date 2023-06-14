#!/bin/bash

# env
source ./set-env.sh

# Source library of functions
source ../lib/qb.shlib
source ../lib/qb.web-api.shlib

echo "=========== raw ==========="
get_torrents && echo "$qbt_torrents"

echo "=========== the list of torrent hash ==========="
qbt_torrent_hashs="$(echo "$qbt_torrents" | $jq_executable ".[].hash" -r)" 
echo "$qbt_torrent_hashs"

echo "=========== the list of peers of torrent hash ==========="
for h in $qbt_torrent_hashs; do 
    echo "hash: $h"
    get_torrent_peers "$h" && echo "$qbt_torrent_peers" | $jq_executable ".peers | to_entries[] | {\
    id:.key,\
    client:.value.client,\
    peer_id_client:.value.peer_id_client,\
    connection:.value.connection,\
    country:.value.country_code\
    }" -c || exit 1
done
