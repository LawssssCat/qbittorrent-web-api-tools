#!/bin/bash

# env
source ./set-env.sh

# Source library of functions
source ../lib/qb.shlib
source ../lib/qb.web-api.shlib

if [ -n "$qbt_torrent_hash" ]; then
    echo "=========== torrents hash ==========="
    echo "$qbt_torrent_hash"
else
    echo "=========== get torrents ==========="
    get_torrents "filter=active" && echo "$qbt_torrents" || exit 1

    echo "=========== get torrents hash ==========="
    qbt_torrent_hashs="$(echo "$qbt_torrents" | $jq_executable ".[].hash" -r)" || exit 1
    echo "$qbt_torrent_hashs"

    echo "=========== select a hash ==========="
    if [ "$(lines_number "$qbt_torrent_hashs")" -le 0 ]; then
        echo "Please add a torrent first." >&2
        exit 1
    fi
    qbt_torrent_hash="$(echo "$qbt_torrent_hashs" | head -n 1)"
    echo "$qbt_torrent_hash"
fi

echo "=========== get torrent trackers ==========="
get_torrent_trackers "$qbt_torrent_hash" && echo "$qbt_torrent_trackers" || exit 1

echo "=========== the list of url ==========="
echo "$qbt_torrent_trackers" | $jq_executable ".[].url" -r
