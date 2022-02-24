function sway_focus_tv
    set tv_outputname (swaymsg -t get_outputs | jq --raw-output '.. | objects | select(.model == "LG TV") | .name')
    swaymsg focus output "$tv_outputname"
end
