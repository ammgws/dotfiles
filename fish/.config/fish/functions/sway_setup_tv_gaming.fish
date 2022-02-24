# Objective is to open Steam Big Picture mode up on the TV and have everything ready to start gaming.
function sway_setup_tv_gaming
    notify-send --hint string:x-dunst-stack-tag:volume --hint int:value:0 --app-name setupTV "Starting gaming mode!"

    lgtv wakeonlan
    # sometime magic packet command seems to hang even though the TV gets turned on...
    sleep 1
    lgtv tv switchInput HDMI_1
    notify-send --hint string:x-dunst-stack-tag:volume --hint int:value:20 --app-name setupTV "TV turned on"

    set tv "'Goldstar Company Ltd LG TV 0x00000101'"
    set tv_outputname (swaymsg -t get_outputs | jq --raw-output '.. | objects | select(.model == "LG TV") | .name')
    set tv_workspace (swaymsg -t get_outputs | jq --raw-output '.. | objects | select(.model == "LG TV") | .current_workspace')

    # If the workspace/output info was empty, it means the TV isn't ready yet,
    # so instead of sleeping we can monitor for workspace events which will happen the TV comes up.
    # TODO: if swaymsg ever gets proper output event support, then can replace this
    # See https://github.com/swaywm/sway/pull/4020
    if not string length --quiet "$tv_workspace"
        notify-send --hint string:x-dunst-stack-tag:volume --hint int:value:40 --app-name setupTV "Waiting for TV workspace"
        swaymsg --type subscribe "['workspace', 'tick']" --monitor | while read --local event
            set first (echo $event | jq --raw-output '.first')
            if string match --quiet $first true
                swaymsg output "$tv" enable
                and swaymsg output "$tv" dpms on
            else
                #set event_type (echo $event | jq --raw-output '.change')
                #string match --quiet $event_type init
                #or continue

                set workspace_num (echo $event | jq --raw-output '.current | .num')
                set output (echo $event | jq --raw-output '.current | .output')
                set output_name (swaymsg --type get_outputs | jq --raw-output ".[] | select(.name == \"$output\") | \"'\" + .make + \" \" + .model + \" \" + .serial + \"'\"")
                string match --quiet "$output_name" "$tv"
                or continue

                # this is needed so that fish exits the loop immediately
                # See https://github.com/fish-shell/fish-shell/issues/1396
                set swaymsg_pids (pidof swaymsg | string split ' ')
                for pid in $swaymsg_pids
                    set swaymsg_parent_pid (ps -o ppid= -p $pid)
                    string match --quiet $swaymsg_parent_pid $fish_pid
                    and kill $pid
                end

                break
            end
        end
        set tv_outputname $output_name
        set tv_workspace $workspace_num
    end

    notify-send --hint string:x-dunst-stack-tag:volume --hint int:value:60 --app-name setupTV "Starting Steam BPM"
    swaymsg exec -- steam-native -start steam://open/bigpicture >/dev/null 2>&1 &

    # big picture mode class is lowercase, normal steam client is capitalised
    # don't know if this is intentional, but is handy for us!
    set steamBPM_container_id (swaymsg -t get_tree | jq -r '.. | select(.window_properties? and .window_properties.class == "Steam") | .pid')
    if string length --quiet "$steamBPM_container_id"
        notify-send --hint string:x-dunst-stack-tag:volume --hint int:value:80 --app-name setupTV "Waiting for Steam BPM to load"
        set steamBPM_container_id (sway_wait_for_window steam)
    end
    notify-send --hint string:x-dunst-stack-tag:volume --hint int:value:90 --app-name setupTV "Moving Steam to TV"
    swaymsg [con_id="$steamBPM_container_id"] move container to workspace "$tv_workspace"
    swaymsg focus output "$tv_outputname"
    swaymsg [con_id="$steamBPM_container_id"] fullscreen

    switchaudio --device TV and
    pamixer --set-volume 100
    systemctl --user stop swayidle
    notify-send --hint string:x-dunst-stack-tag:volume --hint int:value:100 --app-name setupTV "Finished!"
end
