function new_workspace --description="Create new workspace on the current monitor."
    function print_help
        echo "Usage: new_workspace [options]"
        echo "Options:"
        echo (set_color green)"--move-focused"(set_color $fish_color_normal)": Move the currently focused container to the new workspace as well."
    end

    # default values (that can be changed via args)
    set MOVE_FOCUSED 0

    argparse --name new_workspace h/help m/move-focused -- $argv
    or return 1 #error

    if set -lq _flag_help
        print help
        return
    end

    if set -lq _flag_move_focused
        set MOVE_FOCUSED 1
    end

    for workspace in (swaymsg --raw --type get_workspaces | jq --raw-output '.[].name')
        set --append used_workspaces $workspace
    end

    set free_workspaces (seq 1 50)
    for ws in $used_workspaces
        if set --local index (contains --index $ws $free_workspaces)
            set --erase free_workspaces[$index]
        end
    end

    set new_workspace $free_workspaces[1]
    if test $MOVE_FOCUSED = 1
        set focused_container (swaymsg --type get_tree | jq '.. | objects | select(.focused == true) | .id')
        # alternatively: swaymsg --type get_tree | jq --raw-output '.. | (.nodes? // empty)[] | select(.focused==true) | .id'
        swaymsg [con_id="$focused_container"] move workspace $new_workspace
        # swaymsg focus $new_workspace  #this is crashing sway atm...
        swaymsg workspace $new_workspace
    else
        swaymsg workspace $new_workspace
    end
end
