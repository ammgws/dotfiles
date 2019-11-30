function tv_status --description="Return active status of the connected TV to my desktop."
    argparse --name check_xclients 'h/help' 'b/barmode' -- $argv
    or return 1 # error

    function print_help
        echo "Usage: tv_status [options]"
        echo "Options:"
        echo (set_color green)"-b"(set_color $fish_color_normal)": Output text for i3status-rs bar"
    end

    if set -lq _flag_help
        print help
        return
    end

    set MODE std
    if set -lq _flag_barmode
        set MODE bar
    end

    set --local tv_status (swaymsg -t get_outputs | jq --raw-output '.. | objects | select(.model == "LG TV") | .active')
    if test $MODE = bar
        if test $tv_status = "true"
            printf "<span color='green'>📺ON</span>"
        else if test $tv_status = "false"
            printf "<span color='green'>📺OFF</span>"
        end
    else
        echo $tv_status
    end
end
