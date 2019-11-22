function move_all_workspaces --description="Move all workspaces to the currently focused output."
 function print_help
    echo "Usage: move_all_workspaces [options]"
    echo "Options:"
    echo (set_color green)"--from"(set_color $fish_color_normal)": Specify output name from which workspaces are to be moved (defaults to all)."
  end

  argparse --name move_all_workspaces 'f/from=' 'h/help' -- $argv
  or return 1  #error

  if set -lq _flag_help
    print_help
    return
  end

  if set -lq _flag_from
    set from_output $_flag_from
  end

  set current_output (swaymsg -t get_outputs | jq '.[] | select(.focused==true) | .name')

  if set --query from_output
    set workspaces (swaymsg --raw --type get_workspaces | jq --raw-output ".[] | select(.representation != null and .output == \"$from_output\") | .name")
  else
    set workspaces (swaymsg --raw --type get_workspaces | jq --raw-output '.[] | select(.representation != null) | .name')
  end
  for ws in $workspaces
    swaymsg [workspace="$ws"] move workspace to output $current_output
  end
end
