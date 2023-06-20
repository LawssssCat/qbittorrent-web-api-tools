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
qbt_preferences_json="{\"add_trackers\":\"$(lines_join '\\n' "$qbt_net_trackers")\"}"
echo "$qbt_preferences_json"
set_app_preferences "$qbt_preferences_json" || exit 1

echo "=========== \"add_trackers\" in app ==========="
get_app_preferences || {
    echo "response status:"
    echo "$qbt_webapi_response_status"
    echo "error message:"
    echo "$qbt_webapi_response_error"
    exit $EXIT_ERROR
} >&2
qbt_app_trackers_now=$(echo "$qbt_webapi_response_body" | $jq_executable ".add_trackers" -r) || exit 1
echo "$qbt_app_trackers_now"

echo "=========== judge the result ==========="
num_fetch="$(lines_number "$qbt_net_trackers")"
num_app="$(lines_number "$qbt_app_trackers_now")"
if [ "$num_fetch" -eq "$num_app" ]; then
    echo "ok!"
else 
    echo "exception! FETCH,NOW=$num_fetch,$num_app" >&2
    exit 1
fi
