#!/usr/bin/fish

set UNIFI_API_KEY get-from-unifi-video-user-account-page
set UNIFI_SERVER_ADDR https://<hostname or IP>:<port>
set BACKUP_DIR /path/to/backups

set json_file $argv
set camera_name (cat $json_file | jq --raw-output .'meta | .cameraName')
set start_time (date --date=@(math (cat $json_file | jq '.startTime'/1000)) +%Y%m%d_%Hh%Mm%Ss)
set end_time (date --date=@(math (cat $json_file | jq '.endTime'/1000)) +%Y%m%d_%Hh%Mm%Ss)
set record_id (string match --regex '.*/(.*).json' $json_file)[2]
set output_file (string join "_" $start_time "to" $end_time $camera_name ".mp4")

curl --output /tmp/$output_file --insecure (string join "" $UNIFI_SERVER_ADDR "/api/2.0/recording/" $record_id "/download?apiKey=" $UNIFI_API_KEY)
mv /tmp/$output_file $BACKUP_DIR/
