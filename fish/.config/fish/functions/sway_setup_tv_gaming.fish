# Objective is to open Steam Big Picture mode up on the TV and have everything ready to start gaming.
function sway_setup_tv_gaming
    notify-send "Starting gaming mode!"
    lgtv wakeonlan and
    lgtv tv switchInput HDMI_1

    set tv "'Goldstar Company Ltd LG TV 0x00000101'"
    swaymsg output "$tv" enable
    swaymsg output "$tv" dpms on

    # TODO: if swaymsg ever gets proper output event support, then can replace this sleep
    # See https://github.com/swaywm/sway/pull/4020
    sleep 1
    set tv_outputname (swaymsg -t get_outputs | jq --raw-output '.. | objects | select(.model == "LG TV") | .name')
    set tv_workspace (swaymsg -t get_outputs | jq --raw-output '.. | objects | select(.model == "LG TV") | .current_workspace')

    swaymsg exec -- steam-native -start steam://open/bigpicture >/dev/null 2>&1 &

    # big picture mode class is lowercase, normal steam client is capitalised
    # don't know if this is intentional, but is handy for us!
    set steamBPM_container_id (sway_wait_for_window steam)
    swaymsg [con_id="$steamBPM_container_id"] move container to workspace "$tv_workspace"
    swaymsg focus output "$tv_outputname"
    swaymsg [con_id="$steamBPM_container_id"] fullscreen

    switchaudio --device TV and
    pamixer --set-volume 100
    systemctl --user stop swayidle
end
