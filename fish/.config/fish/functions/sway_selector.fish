function sway_selector
    swaymsg --type get_tree | jq -r '.. | select(.pid?) | "\(.pid)\t\(.id)\t\(.name)"' | while read --local pid con_id title
        # TODO handle cases where PID is 0, such as the Steam client
        set --local process_name (cat "/proc/$pid/cmdline")
        echo -- "$title ($process_name)"
    end | wofi --dmenu | read --local selection
    set sel_con (string replace --regex --filter "^\[(\d+)].*" '$1' "$selection")
    swaymsg [con_id="$sel_con"] move container to workspace current
end