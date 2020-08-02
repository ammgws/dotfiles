function sway_preview_outputs --description="Show a screenshot of what is currently on each monitor."
    for name in (swaymsg --raw --type get_outputs | jq --raw-output '.[].name')
        set --append output_names $name
    end

    set current_output (swaymsg -t get_outputs | jq --raw-output '.[] | select(.focused==true) | .name')
    if set --local index (contains --index $current_output $output_names)
        set --erase output_names[$index]
    end

    set target_dir (mktemp --directory --tmpdir outputpreviews.XXXXXXXXXX)
    for output in $output_names
        grim -o $output $target_dir/$output.png
    end

    set config_file "$target_dir"/config
    # single quotes so variables aren't expanded
    echo -e '[options]\ntitle_text = output previews\noverlay_text = output preview\n\n[binds]\n<Return> = exec echo $imv_current_file && kill $imv_pid' >"$config_file"
    set choice (env imv_config="$config_file" imv -f -d "$target_dir")
    set name (string match --regex "$target_dir/(.*).png" "$choice")[2]
    and move_all_workspaces --from "$name"
end
