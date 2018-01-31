#!/usr/bin/fish

set UNIFI_API_KEY get-from-unifi-video-user-account-page
set UNIFI_SERVER_ADDR https://<hostname or IP>:<port>

# shared storage between two containers on my server, it's OK
set SAMBA_USER username
set SAMBA_PASS password
set SAMBA_ADDR //192.168.0.4/Users
set SAMBA_DIR path/to/share

set json_file $argv
set camera_name (cat $json_file | jq --raw-output .'meta | .cameraName')
set start_time (date --date=@(math (cat $json_file | jq '.startTime'/1000)) +%Y%m%d_%Hh%Mm%Ss)
set end_time (date --date=@(math (cat $json_file | jq '.endTime'/1000)) +%Y%m%d_%Hh%Mm%Ss)
set record_id (string match --regex '.*/(.*).json' $json_file)[2]
set output_file (string join "_" $start_time "to" $end_time $camera_name ".mp4")

#curl --remote-name --remote-header-name --insecure (string join "" $UNIFI_SERVER_ADDR "/api/2.0/recording/" $record_id "/download?apiKey=" $UNIFI_API_KEY)
curl --output $output_file --insecure (string join "" $UNIFI_SERVER_ADDR "/api/2.0/recording/" $record_id "/download?apiKey=" $UNIFI_API_KEY)
smbclient --user=$SAMBA_USER%$SAMBA_PASS $SAMBA_ADDR --directory $SAMBA_DIR --command "put $output_file"
