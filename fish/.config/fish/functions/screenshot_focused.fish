function screenshot_focused
    grim -g (sway_getwindowinfo --focused-window | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
end
