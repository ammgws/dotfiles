function sway_getwindowinfo
    argparse --name sway_getwindowinfo h/help f/focused-window -- $argv
    or return 1

    if set -lq _flag_focused_window
        swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible? and .focused?)'
        return 0
    end

    if test (count $argv) -eq 3
        set x_sel $argv[1]
        set y_sel $argv[2]
        set output_name $argv[3]
    else
        slurp -p -f "%x %y %o" | read x_sel y_sel output_name
        or return 1
    end

    for rect in (swaymsg -t get_tree | jq -r ".. | objects | select(.name == \"$output_name\") | recurse | select(.pid? and .visible?) | .rect | \"\(.x) \(.width) \(.y) \(.height)\"")
        echo $rect | read x1 w y1 h
        set x2 (math $x1 + $w)
        set y2 (math $y1 + $h)
        if test \( $x_sel -ge $x1 \) -a \( $x_sel -le $x2 \)
            and test \( $y_sel -ge $y1 \) -a \( $y_sel -le $y2 \)
            swaymsg --type get_tree | jq ".. | objects | select(.name == \"$output_name\") | recurse | select(.pid? and .visible?) | select(.rect.x == $x1 and .rect.y == $y1 and .rect.width == $w and .rect.height == $h)"
        end
    end
end
