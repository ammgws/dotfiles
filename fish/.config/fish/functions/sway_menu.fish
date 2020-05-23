function sway_menu
    ibus engine xkb::us::eng 2&>/dev/null
    #bemenu -i
    wofi --show drun --allow-images --insensitive 2>/dev/null | read --delimiter % a _
    printf $a
end