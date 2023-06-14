#!/bin/bash

# env
source ./set-env.sh

# Source library of functions
source ../lib/qb.shlib
source ../lib/qb.web-api.shlib

echo "=========== raw ==========="
: ${example__get_torrent_trackers__get_trackers:="1ff0a7472d8fc6c589a79ad2db6871cbfb0fab89"}
get_torrent_trackers "$example__get_torrent_trackers__get_trackers" && echo "$qbt_torrent_trackers" 

echo "=========== the list of url ==========="
echo "$qbt_torrent_trackers" | $jq_executable ".[].url"
