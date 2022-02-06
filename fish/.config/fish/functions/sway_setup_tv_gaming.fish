function sway_setup_tv_gaming
    notify-send "Starting gaming mode!"
    lgtv wakeonlan and
    lgtv tv switchInput HDMI_1

    set tv "'Goldstar Company Ltd LG TV 0x00000101'"
    swaymsg output "$tv" enable
    swaymsg output "$tv" dpms on

    set tv_outputname (swaymsg -t get_outputs | jq --raw-output '.. | objects | select(.model == "LG TV") | .name')
    set tv_workspace (swaymsg -t get_outputs | jq --raw-output '.. | objects | select(.model == "LG TV") | .current_workspace')

    swaymsg exec -- steam-native -start steam://open/bigpicture >/dev/null 2>&1 &
    sleep 5
    # big picture mode class is lowercase, normal steam client is capitalised
    # don't know if this is intentional, but is handy for us!
    swaymsg [class=steam] move container to workspace "$tv_workspace"
    swaymsg focus output "$tv_outputname"
    swaymsg [class=steam] fullscreen
    switchaudio --device TV and
    pamixer --set-volume 100
end
