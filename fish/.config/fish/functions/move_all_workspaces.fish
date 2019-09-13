function move_all_workspaces --description="Move all workspaces to the currently focused output."
  set current_output (swaymsg -t get_outputs | jq '.[] | select(.focused==true) | .name')
  for ws in (swaymsg --raw --type get_workspaces | jq --raw-output '.[].name')
    swaymsg [workspace="$ws"] move workspace to output $current_output
  end
end
