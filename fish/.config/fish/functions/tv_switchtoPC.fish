function tv_switchtoPC
    lgtv wakeonlan
    # sometime magic packet command seems to hang even though the TV gets turned on...
    sleep 1
    lgtv tv switchInput HDMI_1

    set tv "'Goldstar Company Ltd LG TV 0x00000101'"
    swaymsg output "$tv" enable
    swaymsg output "$tv" dpms on
end
