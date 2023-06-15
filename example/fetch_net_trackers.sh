#!/bin/bash

# env
source ./set-env.sh

# Source library of functions
source ../lib/qb.shlib
source ../lib/qb.web-api.shlib

echo "=========== urls ==========="
: ${example__fetch_net_trackers__fetch_urls:="http://example_2.com http://example_3.com"}
fetch_urls=(
    $example__fetch_net_trackers__fetch_urls
    https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt # https://github.com/ngosang/trackerslist
    https://cf.trackerslist.com/best.txt # https://github.com/XIU2/TrackersListCollection
    https://newtrackon.com/api/stable # https://newtrackon.com/
    https://cdn.jsdelivr.net/gh/DeSireFire/animeTrackerList/AT_best.txt # https://github.com/DeSireFire/animeTrackerList
    http://example.com # test exception
)
echo "${fetch_urls[@]}" | tr " " "\n"

echo "=========== fetch ==========="
fetch_net_trackers "${fetch_urls[@]}"

echo "=========== result ==========="
echo "$qbt_net_trackers"

echo "=========== exception ==========="
exception_urls="$(echo "$qbt_net_exception_urls" | tr ' ' '\n' | grep -v -e 'example')"
if [ -n "$exception_urls" ]; then
    echo "$exception_urls"
    exit 1
fi
