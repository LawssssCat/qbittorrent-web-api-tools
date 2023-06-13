#!/bin/bash

# env
source ./set-env.sh

# Source library of functions
source ../lib/qb.shlib
source ../lib/qb.web-api.shlib

echo "=========== raw ==========="
get_torrent_trackers "1ff0a7472d8fc6c589a79ad2db6871cbfb0fab89" && echo "$qbt_torrent_trackers" 

echo "=========== the list of url ==========="
echo "$qbt_torrent_trackers" | $jq_executable ".[].url"
