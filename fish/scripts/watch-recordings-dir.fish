#!/usr/bin/fish

set UNIFI_RECORDINGS_DIR /path/to/recordings

fswatch --print0 --directories --recursive --event Created --exclude '.*' --include '\.json$' $UNIFI_RECORDINGS_DIR | xargs --verbose --null --max-args=1 --replace='{}' '/path/to/backup-recording.fish' "{}"
