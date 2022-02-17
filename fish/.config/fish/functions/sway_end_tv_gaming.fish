function sway_end_tv_gaming
    set tv "'Goldstar Company Ltd LG TV 0x00000101'"
    lgtv system turnOff
    swaymsg output "$tv" disable
    swaymsg output "$tv" dpms off
    pamixer --set-volume 25; and switchaudio --device headphones
    systemctl --user start swayidle
end
