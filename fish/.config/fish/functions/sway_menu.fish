function sway_menu
    #bemenu -i
    wofi --show drun --allow-images --insensitive 2>/dev/null | read --delimiter % a _
    printf $a
end
