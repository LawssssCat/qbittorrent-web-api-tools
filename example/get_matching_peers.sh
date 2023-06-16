#!/bin/bash

# env
source ./set-env.sh

# Source library of functions
source ../lib/qb.shlib
source ../lib/qb.web-api.shlib

echo "=========== pattern ==========="
: ${example__get_matching_peers__matching_pattern:="Xunlei|\-XL"}
echo "$example__get_matching_peers__matching_pattern"

echo "=========== torrent hash ==========="
get_matching_peers "$example__get_matching_peers__matching_pattern" && echo "$qbt_mached_peers" || exit 1

echo "=========== torrent hash id ==========="
echo "$qbt_mached_peers" | $jq_executable ".key" -r
