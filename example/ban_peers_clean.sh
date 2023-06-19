#!/bin/bash

# env
source ./set-env.sh

# Source library of functions
source ../lib/qb.shlib
source ../lib/qb.web-api.shlib

echo "=========== set preference: add_trackers ==========="
set_app_preferences '{"banned_IPs":""}' && echo "$qbt_webapi_response"

echo "=========== get preference: add_trackers ==========="
get_app_preferences && 
qbt_qpp_banned_IPs="$(echo "$qbt_app_preferences" | $jq_executable ".banned_IPs" -r)" || exit 1
echo "$qbt_qpp_banned_IPs"

if [ "$(lines_number "qbt_qpp_banned_IPs")" -ne "0" ]; then
    echo "Fail to clean banned_IPS. remain=$(lines_number "qbt_qpp_banned_IPs")"
    exit 1
fi
