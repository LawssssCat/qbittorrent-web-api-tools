#!/bin/bash

# env
source ./set-env.sh

# Source library of functions
source ../lib/qb.shlib
source ../lib/qb.web-api.shlib

echo "=========== set preference: add_trackers ==========="
# change
set_app_preferences '{"add_trackers":"https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt"}' && echo "$qbt_webapi_response"

echo "=========== get preference: add_trackers ==========="
get_app_preferences && echo "$qbt_app_preferences" | $jq_executable ".add_trackers" -r
