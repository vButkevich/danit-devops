#!/bin/bash

# Write script which watching directory "~/watch". 
# If it sees that there appeared a new file, 
# it prints files content and rename it to *.back

set -euo pipefail

function watch-directory(){

local WATCH_DIR="$HOME/watch"
echo "Watching directory: $WATCH_DIR"

inotifywait -m -e close_write --format '%w%f' "$WATCH_DIR" | while read -r full_name; do
    if [[ -f "$full_name" ]]; then
        echo "=== New file detected: $full_name ==="
        cat "$full_name"
        mv -- "$full_name" "${full_name}.back"
        echo "Renamed to: ${full_name}.back"
    fi
done
}

main(){ 
    watch-directory
}
main

: <<'COMMENT'
watcher.service
[Unit]
Description=Watch ~/watch directory and process new files
After=network.target

[Service]
Type=simple
User=bob
WorkingDirectory=/home/bob
ExecStart=/home/bob/watch_dir.sh
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
>>EOF


sudo systemctl daemon-reload
sudo systemctl enable watcher.service
sudo systemctl start watcher.service

sudo systemctl status watcher.service
journalctl -u watcher.service -f

COMMENT