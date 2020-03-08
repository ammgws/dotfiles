function sway_selector
    swaymsg --type get_tree | jq -r '.. | select(.pid?) | select(.pid != 0) | "\(.pid)\t\(.id)\t\(.name)"' | while read --local pid con_id title
        set --local process_name (cat "/proc/$pid/cmdline")
        echo -- "[$con_id] $title ($process_name)"
    end | wofi --dmenu | read --local selection
    set sel_con (string replace --regex --filter "^\[(\d+)].*" '$1' "$selection")
    swaymsg [con_id="$sel_con"] move container to workspace current
end