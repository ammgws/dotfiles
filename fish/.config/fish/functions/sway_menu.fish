function sway_menu
    ibus engine xkb::us::eng 2&>/dev/null
    set --local menu_cmd "bemenu -i"
    set --local menu_cmd "wofi --fork --show drun --allow-images"
    j4-dmenu-desktop --no-generic --dmenu="$menu_cmd" --term="kitty" --usage-log=$XDG_CACHE_HOME/appmenu.history
end