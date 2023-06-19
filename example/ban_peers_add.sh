#!/bin/bash

# env
source ./set-env.sh

# Source library of functions
source ../lib/qb.shlib
source ../lib/qb.web-api.shlib

echo "=========== the peers ready to ban ==========="
: ${example__add_ban_peers__ban_peers:="11.11.11.11:6881 22.22.22.22:6882"}
echo "$example__add_ban_peers__ban_peers"

echo "=========== ban peers ==========="
add_ban_peers "$example__add_ban_peers__ban_peers" && echo "ok" || exit 1

echo "=========== the banPeers in app preferences (raw format) ==========="
get_app_preferences && echo "$qbt_app_preferences" | $jq_executable ". | {banned_IPs}"
