function switchaudio --description 'Switch between audio devices and move all current audio outputs to the new device.'
    # model name of the TV. Can find via `swaymsg -t get_outputs` or `pactl list cards`
    set TV_MODEL_NAME "LG TV"

    function print_help
        echo "Usage: switchaudio [options]"
        echo "Options:"
        echo (set_color green)"-d/--device"(set_color $fish_color_normal)": Switch to the specified device."
        echo (set_color green)"-k/--keep"(set_color $fish_color_normal)": Switch audio device but leave current sinks alone."
        echo (set_color green)"-m/--menu"(set_color $fish_color_normal)": Display menu to choose from."
    end

    argparse --name switchaudio h/help m/menu k/keep 'd/device=' -- $argv
    or return 1 #error

    if set -lq _flag_help
        print_help
        return
    end

    if set -lq _flag_device
        set device $_flag_device
    end

    if set -lq _flag_keep
        set keep_sinks 1
    end

    # use menu by default for now. Add in terminal menu later.
    set use_menu 1
    if set -lq _flag_menu
        set use_menu 1
    end

    function prettify_name --argument-names sink_raw_name
        if string match --quiet '*Pebbles*' $sink_raw_name
            echo upstairs_speakers
        else if string match --quiet '*Sound_Blaster_Play*' $sink_raw_name
            echo downstairs_speakers
        else if string match --quiet 'alsa_output.pci-0000_00_1b.0.analog-stereo' $sink_raw_name
            echo headphones
            # pipewire
        else if string match --quiet 'alsa_output.pci-0000:00:1b.0.analog-stereo' $sink_raw_name
            echo headphones
        else if string match --quiet '*PCH*' $sink_raw_name
            echo headphones
        else if string match --quiet 'bluez_sink*' $sink_raw_name
            echo bluetooth
        else if string match --quiet 'alsa_output.pci-0000_01_00.1.hdmi-stereo-extra*' $sink_raw_name
            echo TV
            # pipewire    
        else if string match --quiet 'alsa_output.pci-0000:01:00.1.hdmi-stereo-extra*' $sink_raw_name
            echo TV
        else
            echo $sink_raw_name
        end
    end

    function get_icon --argument-names output_device
        switch $output_device
            case headphones
                echo "🎧"
            case speakers
                echo "🔈"
            case bluetooth
                echo BT
            case TV
                echo "📺"
            case '*'
                echo "??"
        end
    end

    function get_sink_volume --argument-names sink_name
        pactl list sinks | grep --after-context=15 "Name: $sink_name\$" |
            grep 'Volume:' | string match --regex '^((?!Base Volume:).)*$' |
            string replace --regex --filter ".* (\d+)%.*" '$1'
    end

    set sinks (pactl list short sinks 2> /dev/null)
    if test $status -ne 0
        echo "Error calling `pactl`" >&2
        return 1
    end
    set default_sink_name (pactl info | sed -En 's/Default Sink: (.*)/\1/p')

    if not set --query device
        for sink in $sinks
            set sink_info (string split \t $sink)
            set sink_name $sink_info[2]
            set sink_name_pretty (prettify_name $sink_name)
            if test "$sink_name" = "$default_sink_name"
                set sink_name_pretty "$sink_name_pretty (current)"
            end
            set device_choices (string join "\n" $device_choices $sink_name_pretty)
        end
        if set --query SSH_CLIENT
            set device (echo -e "$device_choices" | fzf)
        else
            #set device (echo -e "$device_choices" | bemenu --ignorecase --wrap --index 1 --prompt "Select new sound output:" --monitor all)
            set device (echo -e "$device_choices" | wofi --show dmenu)
        end
        set device (string split --fields 1 "(current)" -- $device | string trim)
        if not string length --quiet $device
            echo "no device selected"
            return 1
        end
    end

    for sink in $sinks
        set sink_info (string split \t $sink)
        set sink_name $sink_info[2]
        set sink_name_pretty (prettify_name $sink_name)
        set sink_state $sink_info[5]
        if string match --quiet "$sink_name_pretty" "$device"
            set new_default_sink_name $sink_name
            set new_default_sink_name_pretty $sink_name_pretty
            break
        end
    end

    # If the output we switch to is not set as default then the
    # system volume slider controls will not affect it.
    if string length --quiet $new_default_sink_name
        pactl set-default-sink $new_default_sink_name
    else
        echo "default sink not changed. bug?"
    end

    set new_sink_volume (get_sink_volume $default_sink_name)
    if test $new_sink_volume -gt 100
        set new_sink_volume 100
    end
    pactl set-sink-volume @DEFAULT_SINK@ "$new_sink_volume%"

    if not set --query keep_sinks
        set inputs (pactl list short sink-inputs)
        for input in $inputs
            set input_id (string split --field 1 \t $input)
            pactl move-sink-input $input_id @DEFAULT_SINK@
        end
    end

    # For the TV, ensure the card profile is set to the correct HDMI port, otherwise we get no sound.
    if test "$new_default_sink_name" = TV
        # Get the first profile listed after "Part of profile(s):" for the HDMI port the TV is connected to.
        # Will probably be 'output:hdmi-stereo-extra*'. TODO: Will I ever want the non-stereo profiles?
        set TV_hdmi_port_profile (pactl list cards | \
      grep --after-context=100 "Name: alsa_card.pci-0000_01_00.1" | \
      sed '/Card/Q' | \
      grep --after-context=1 "$TV_MODEL_NAME" | \
      string match --regex '(output:hdmi-[^,]+)')[2]
        or return 1

        set active_profile (pactl list cards | \
                     grep --after-context=100 "Name: alsa_card.pci-0000_01_00.1" | \
                     sed '/Card/Q' | \
                     string match --regex 'Active Profile: (output:hdmi-.+)')[2]

        if test "$TV_hdmi_port_profile" != "$active_profile"
            pactl set-card-profile alsa_card.pci-0000_01_00.1 $TV_hdmi_port_profile
        end
    end

    string length --quiet $new_default_sink_name
    or return 1
end
