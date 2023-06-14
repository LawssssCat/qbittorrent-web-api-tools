#!/bin/bash

# env
source ./set-env.sh

# Source library of functions
source ../lib/qb.shlib
source ../lib/qb.web-api.shlib

echo "=========== set preference: add_trackers ==========="
: ${example__set_app_preferences__add_trackers:="https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt"}
set_app_preferences "{\"add_trackers\":\"$example__set_app_preferences__add_trackers\"}" && echo "$qbt_webapi_response"

echo "=========== get preference: add_trackers ==========="
get_app_preferences && 
example__set_app_preferences__get_trackers="$(echo "$qbt_app_preferences" | $jq_executable ".add_trackers" -r)" 
echo "$example__set_app_preferences__get_trackers"

if [[ ! "$example__set_app_preferences__get_trackers" == "$example__set_app_preferences__add_trackers" ]]; then
    exit 1
fi
