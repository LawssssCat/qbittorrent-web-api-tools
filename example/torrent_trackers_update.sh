#!/bin/bash

# env
source ./set-env.sh

# Source library of functions
source ../lib/qb.shlib
source ../lib/qb.web-api.shlib

echo "=========== get add_trackers ==========="
get_app_preferences && 
qbt_add_tracker="$(echo "$qbt_app_preferences" | $jq_executable ".add_trackers" -r)" || exit 1
echo "add num: $(lines_number "$qbt_add_tracker")"
qbt_add_tracker_urls="$(echo "$qbt_add_tracker" | lines_join '%0A')"
echo "$qbt_add_tracker_urls"

if [ -z "$qbt_add_tracker_urls" ]; then
    echo "Please add \"add_trackers\" preference first." >&2
    exit 1
fi

echo "=========== get active torrents ==========="
get_torrents "filter=active&sort=dlspeed" && 
qbt_active_torrents="$(echo "$qbt_torrents" | $jq_executable 'sort_by(.upspeed) | .[]' -c | head -n 10 \
| $jq_executable '. | {name,hash,state,dlspeed,upspeed}' -c)" || exit 1
echo "ok"
# qbt_active_torrents='{"name":"test","hash":"a4287af13929df7e2050e55ab6d5681d0f76fef4"}'

echo "=========== update (remove & add) torrent trackers ==========="
# status https://github.com/qbittorrent/qBittorrent/wiki/WebUI-API-(qBittorrent-4.1)#get-torrent-trackers
qbs_tracker_num_old=0
qbs_tracker_num_remove=0
qbs_tracker_num_new=0
while read qbt_torrent; do
    echo "[current torrent] $qbt_torrent"
    qbt_torrent_hash="$(echo "$qbt_torrent" | $jq_executable '.hash' -r)"
    # old
    qbt_torrent_trackers_old="$(get_torrent_trackers "$qbt_torrent_hash" && echo "$qbt_torrent_trackers" | $jq_executable '.[]' -c)"
    ((qbs_tracker_num_old+=$(lines_number "$qbt_torrent_trackers_old")))
    # remove
    qbt_remove_trackers="$(echo "$qbt_torrent_trackers_old" | $jq_executable '. | select(.status == 4) | select(.num_peers <= -1)' -c)" || exit 1
    echo "remove num: $(lines_number "$qbt_remove_trackers")"
    echo "$qbt_remove_trackers"
    ((qbs_tracker_num_remove+=$(lines_number "$qbt_remove_trackers")))
    qbt_remove_tracker_urls="$(echo "$qbt_remove_trackers" | $jq_executable '.url' -r | lines_join '|')"
    echo "$qbt_remove_tracker_urls"
    remove_torrent_trackers "$qbt_torrent_hash" "$qbt_remove_tracker_urls" || exit 1
    # add
    echo "adding add_trackers ..."
    add_torrent_trackers "$qbt_torrent_hash" "$qbt_add_tracker_urls" || exit 1
    # new
    qbt_torrent_trackers_new="$(get_torrent_trackers "$qbt_torrent_hash" && echo "$qbt_torrent_trackers" | $jq_executable '.[]' -c)"
    ((qbs_tracker_num_new+=$(lines_number "$qbt_torrent_trackers_new")))
    # sleep
done <<< "$qbt_active_torrents"

echo "=========== stats ==========="
echo "ok! torrents:$(lines_number "$qbt_active_torrents"); \
tracker add,old,remove,new=$(lines_number "$qbt_add_tracker"),$qbs_tracker_num_old,$qbs_tracker_num_remove,$qbs_tracker_num_new"

