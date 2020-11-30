function check_xclients --description="Return number of current X clients"
    argparse --name check_xclients h/help b-barmode m-menu -- $argv
    or return 1 # error

    # TODO: get info from swaymsg so can remove this dependency
    if not type -q xlsclients
        echo (set_color red)"You must have xlsclients installed."(set_color $fish_color_normal)
        return 1
    end

    function print_help
        echo "Usage: check_xclients [options]"
        echo "Options:"
        echo (set_color green)"--barmode"(set_color $fish_color_normal)": Output text for i3status-rs bar"
        echo (set_color green)"--menu"(set_color $fish_color_normal)": Show popup menu with list of clients"
    end

    if set -lq _flag_help
        print help
        return
    end

    set val (xlsclients | wc --lines)
    if set -lq _flag_barmode
        # use hide_when_empty in i3status-rs block config
        if test "$val" = 0
            printf ""
        else if not string length --quiet "$val"
            printf ""
        else
            printf "<span color='red'>X11: $val</span>"
        end
    else if set -lq _flag_menu
        xlsclients | string sub --start (math (string length -- $hostname) + 3) | wofi --show dmenu
    else
        echo $val
    end
end
