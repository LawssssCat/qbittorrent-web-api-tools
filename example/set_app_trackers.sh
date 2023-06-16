#!/bin/bash

# env
source ./set-env.sh

# Source library of functions
source ../lib/qb.shlib
source ../lib/qb.web-api.shlib

echo "=========== mock trackers ==========="
qbt_net_trackers="
http://tracker.electro-torrent.pl/announce
http://1337.abcvg.info/announce
https://trackme.theom.nz:443/announce
https://tr.abiir.top/announce
https://tracker.gbitt.info/announce
udp://tracker.sylphix.com:6969/announce
"
echo "$qbt_net_trackers"

echo "=========== set tracker ==========="
set_app_preferences "{\"add_trackers\":\"$(echo "$qbt_net_trackers" | sed ':a; N; $!ba; s/\n/\\n/g')\"}" || exit 1

echo "=========== \"add_trackers\" in app ==========="
get_app_preferences && 
qbt_app_trackers_now=$(echo "$qbt_app_preferences" | $jq_executable ".add_trackers" -r) || exit 1
echo "$qbt_app_trackers_now"

echo "=========== judge the result ==========="
num_fetch="$(echo "$qbt_net_trackers" | grep -E -v '^( )*$' | wc -l)"
num_app="$(echo "$qbt_app_trackers_now" | grep -E -v '^( )*$' | wc -l)"
if [ "$num_fetch" -eq "$num_app" ]; then
    echo "ok!"
else 
    echo "exception! FETCH,NOW=$num_fetch,$num_app" >&2
    exit 1
fi
