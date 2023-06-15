
qbittorrent web-api: https://github.com/qbittorrent/qBittorrent/wiki/WebUI-API-(qBittorrent-4.1)

jq tutorial: https://jqlang.github.io/jq/tutorial/

## Usage

load functions

```bash
# env
: ${qbt_host:="http://127.0.0.1"}
: ${qbt_port:="8080"}
: ${qbt_username:="admin"}
: ${qbt_password:="adminadmin"}

# Source library of functions
source ../lib/qb.shlib
source ../lib/qb.web-api.shlib
```

---

call functions

e.g. fetch tracker from net and set it to app preference "add_trackers".

```bash
fetch_net_trackers "http://example1.com https://example2.com"
set_app_preferences "{\"add_trackers\":\"$qbt_net_trackers\"}"
```

e.g. ban peers that look like they are from XunLei —— `get_matching_peers.sh`

e.g. clean banned peers

```bash
set_app_preferences '{"banned_IPs":""}'
```

## Test

```bash
$ cd ./test
$ ./test-example.sh
 · EXAMPLE_0: add_ban_peers.sh .................................  SUCCESS
 · EXAMPLE_1: fetch_net_trackers.sh ............................  SUCCESS
 · EXAMPLE_2: get_app_preferences.sh ...........................  SUCCESS
 · EXAMPLE_3: get_torrent_peers.sh .............................  SUCCESS
 · EXAMPLE_4: get_torrents.sh ..................................  SUCCESS
 · EXAMPLE_5: get_torrent_trackers.sh ..........................  SUCCESS
 · EXAMPLE_6: set_app_preferences.sh ...........................  SUCCESS
```

## Alternate

+ https://github.com/fedarovich/qbittorrent-cli —— qbt cli 
+ https://github.com/Jorman/Scripts/blob/master/AddqBittorrentTrackers.sh —— tracker subscription
