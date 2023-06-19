#!/bin/bash

# env
source ./set-env.sh

# Source library of functions
source ../lib/qb.shlib
source ../lib/qb.web-api.shlib

echo "=========== raw ==========="
get_app_preferences && echo "$qbt_app_preferences" || exit 1

echo "=========== json format ==========="
echo "$qbt_app_preferences" | $jq_executable "." || exit 1

echo "=========== add_trackers ==========="
echo "$qbt_app_preferences" | $jq_executable "{add_trackers_enabled,add_trackers}"
echo "=========== the value of add_trackers ==========="
echo "$qbt_app_preferences" | $jq_executable ".add_trackers" -r
