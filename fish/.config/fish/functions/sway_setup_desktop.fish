function sway_setup_desktop --description "Setup inputs and outputs for my desktop PC"
    function print_help
        echo "Usage: " (status current-command) "[options]"
        echo "Options:"
        echo (set_color green)"-d --debug"(set_color $fish_color_normal)": Enable debug output"
        echo (set_color green)"-t --toggle"(set_color $fish_color_normal)": Toggle between upstairs and downstairs mode"       
        echo (set_color green)"-m<name> --mode=<name>"(set_color $fish_color_normal)": Specify mode to switch to"
    end

    argparse h/help t-toggle m/mode= -- $argv
    or return 1 #error

    if set -lq _flag_help
        print help
        return
    end

    if set -lq _flag_toggle
        set MODE toggle
    end

    if set -lq _flag_mode
        if not contains $_flag_mode upstairs downstairs all tv
            echo Valid modes are: upstairs downstairs all tv
            return 1
        end
        set MODE $_flag_mode
    end

    # sway co-ordinates
    #       0     1920    3840
    # 0     _______________
    #       |      |      |
    #       | up L | up R |    upstairs
    # 1080  |______|______|
    #        ______ ______
    #       |      |      |
    #       | dn L | dn R |    downstairs
    # 2160  |______|______|

    ### Output configuration
    # double quotes are necessary so that it is passed as one arg to swaymsg
    set upstairs_monitorL "'Acer Technologies Acer KA270H T3QSJ0014200'"
    set upstairs_monitorR "'Ancor Communications Inc ASUS VP278 K3LMTF030840'"
    set downstairs_monitorL "'Make Model Serial'"
    set downstairs_monitorR "'Samsung Electric Company S27A950D 0x00000000'"
    set tv "'Goldstar Company Ltd LG TV 0x00000101'"

    set upstairs_keyboard "1133:49706:Gaming_Keyboard_G110"
    set upstairs_mouse "5426:22:Razer_Razer_DeathAdder"
    set downstairs_keyboard "9610:42:SINO_WEALTH_Gaming_KB"
    set downstairs_mouse "1133:49284:Logitech_G102_Prodigy_Gaming_Mouse"

    # Use mouse status as indicator of current mode
    set upstairs_mouse_status (swaymsg --type get_inputs | jq -r ".[] | select(.identifier == \"$upstairs_mouse\") | .libinput | .send_events")
    if string match --quiet $upstairs_mouse_status enabled
        set current_mode upstairs
    else
        set current_mode downstairs
    end

    if string match --quiet $MODE toggle
        if string match --quiet $current_mode upstairs
            set next_mode downstairs
        else
            set next_mode upstairs
        end
    else
        set next_mode $MODE
    end

    if string match --quiet $next_mode upstairs
        swaymsg output "$upstairs_monitorL" enable
        swaymsg output "$upstairs_monitorR" enable
        swaymsg output "$upstairs_monitorL" pos 0 0 res 1920x1080
        swaymsg output "$upstairs_monitorR" pos 1920 0 res 1920x1080
        swaymsg input "$upstairs_mouse" events enabled
        swaymsg output "$downstairs_monitorL" disable
        swaymsg output "$downstairs_monitorR" disable
        swaymsg input "$downstairs_mouse" events disabled
    else if string match --quiet $next_mode downstairs
        swaymsg output "$downstairs_monitorL" enable
        swaymsg output "$downstairs_monitorR" enable
        swaymsg output "$downstairs_monitorL" pos 0 0 res 1920x1080
        swaymsg output "$downstairs_monitorR" pos 1920 0 res 1920x1080
        swaymsg input "$downstairs_mouse" events enabled
        swaymsg output "$upstairs_monitorL" disable
        swaymsg output "$upstairs_monitorR" disable
        swaymsg input "$upstairs_mouse" events disabled
    else if string match --quiet $next_mode all
        swaymsg output "$upstairs_monitorL" enable
        swaymsg output "$upstairs_monitorR" enable
        swaymsg output "$upstairs_monitorL" pos 0 0 res 1920x1080
        swaymsg output "$upstairs_monitorR" pos 1920 0 res 1920x1080   
        swaymsg output "$downstairs_monitorL" enable
        swaymsg output "$downstairs_monitorR" enable
        swaymsg output "$downstairs_monitorL" pos 0 1080 res 1920x1080
        swaymsg output "$downstairs_monitorR" pos 1920 1080 res 1920x1080
    end
    echo "Changed to $next_mode mode"
end
