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
    https://cdn.jsdelivr.net/gh/ngosang/trackerslist@master/trackers_best_ip.txt # https://github.com/ngosang/trackerslist
    https://cf.trackerslist.com/best.txt # https://github.com/XIU2/TrackersListCollection
    https://newtrackon.com/api/stable # https://newtrackon.com/
    https://cdn.jsdelivr.net/gh/DeSireFire/animeTrackerList/AT_best.txt # https://github.com/DeSireFire/animeTrackerList
    http://example.com # test exception
)
echo "${fetch_urls[@]}" | tr " " "\n"

echo "=========== fetch ==========="
fetch_net_trackers "${fetch_urls[@]}" || exit 1

echo "=========== result ==========="
echo "$qbt_net_trackers"

echo "=========== exception ==========="
qbt_fetch_exception=0

for ((i=0; i<${#qbt_net_exception_urls[@]}; i++)); do
    if [ -n "$(echo "${qbt_net_exception_issues[$i]}" | grep -v -e 'example')" ]; then
        qbt_fetch_exception=1
        echo "Fail to fetch \"${qbt_net_exception_urls[$i]}\" with issue: ${qbt_net_exception_issues[$i]}" >&2
    fi
done

if [ "$qbt_fetch_exception" -eq 1 ]; then
    exit 1
else
    echo "No exceptions"
fi
