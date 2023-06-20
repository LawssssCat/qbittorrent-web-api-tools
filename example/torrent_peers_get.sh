#!/bin/bash

# env
source ./set-env.sh

# Source library of functions
source ../lib/qb.shlib
source ../lib/qb.web-api.shlib

echo "=========== search params ==========="
qbt_torrent_search_params="filter=$active"
echo "$qbt_torrent_search_params"

echo "=========== the list of torrent ==========="
get_torrents "$qbt_torrent_search_params" && 
qbt_torrents="$(echo "$qbt_torrents")" || exit 1
if [ -z "$qbt_torrents" ]; then
    echo "Torrent Unfound. Please ensure that at least one torrent is active." >&2
    exit 1
fi
echo "$qbt_torrents" 

echo "=========== the list of torrent hash ==========="
qbt_torrent_hashs="$(echo "$qbt_torrents" | $jq_executable ".[].hash" -r)" || exit 1
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
