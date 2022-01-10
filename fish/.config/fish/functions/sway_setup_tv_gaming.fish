function sway_setup_tv_gaming
    lgtv wakeonlan
    lgtv tv switchInput HDMI_1

    set tv "'Goldstar Company Ltd LG TV 0x00000101'"

    swaymsg output "$tv" enable
    set tv_outputname (swaymsg -t get_outputs | jq --raw-output '.. | objects | select(.model == "LG TV") | .name')
    set tv_workspace (swaymsg -t get_outputs | jq --raw-output '.. | objects | select(.model == "LG TV") | .current_workspace')

    steam-native -start steam://open/bigpicture &
    # big picture mode class is lowercase, normal steam client is capitalised
    # don't know if this is intentional, but is handy for us!
    swaymsg [class=steam] move container to workspace "$tv_workspace"
    swaymsg focus output "$tv_outputname"
    switchaudio --device TV and; pamixer --set-volume 100
end