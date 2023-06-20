#!/bin/bash

# env
source ./set-env.sh

# Source library of functions
source ../lib/qb.shlib
source ../lib/qb.web-api.shlib

echo "=========== set preference ==========="
: ${example__ban_peers_clean__banned_IPs:-} # e.g. 0.0.0.11\n0.0.0.22
echo "$example__ban_peers_clean__banned_IPs"

echo "=========== set preference ==========="
set_app_preferences '{"banned_IPs":"'$example__ban_peers_clean__banned_IPs'"}' && echo "Ok" || {
    echo "response status:"
    echo "$qbt_webapi_response_status"
    echo "error message:"
    echo "$qbt_webapi_response_error"
    exit $EXIT_ERROR
} >&2

echo "=========== get preference ==========="
get_app_preferences  || {
    echo "response status:"
    echo "$qbt_webapi_response_status"
    echo "error message:"
    echo "$qbt_webapi_response_error"
    exit $EXIT_ERROR
} >&2
qbt_qpp_banned_IPs="$(echo "$qbt_webapi_response_body" | $jq_executable ".banned_IPs" -r)" || exit $EXIT_ERROR
echo "\"$qbt_qpp_banned_IPs\""

echo "=========== check preference ==========="
if [ "$qbt_qpp_banned_IPs" == "$(echo -e "$example__ban_peers_clean__banned_IPs")" ]; then
    echo "Ok"
else
    echo "Fail" >&2
    exit $EXIT_ERROR
fi
