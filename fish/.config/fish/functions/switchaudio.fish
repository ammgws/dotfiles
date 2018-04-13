function switchaudio --description 'Switch between audio outputs'
    function prettify_name --argument-names sink_raw_name
        if string match --quiet '*Pebbles*' $sink_raw_name
            echo "speakers"
        else if string match --quiet '*pci*' $sink_raw_name
            echo "headphones"
        else if string match --quiet 'bluez_sink*' $sink_raw_name
            echo "bluetooth"
        else
            echo $sink_raw_name
        end
    end

    function get_icon --argument-names output_device
        if string match --quiet 'headphones' $output_device
            echo "🎧"
        else if string match --quiet 'speakers' $output_device
            echo "🔈"
        else if string match --quiet 'bluetooth' $output_device
            echo "BT"
        else
            echo "??"
        end
    end

    function get_default_sink
        echo (pacmd list-sinks | awk '/* index:/{print $3}')
    end

    set default_sink_id (get_default_sink)
    set sinks (pactl list short sinks)

    for sink in $sinks
       set sink_info (string split \t $sink)
       set sink_id $sink_info[1]
       set sink_name (prettify_name $sink_info[2])
       set sink_state $sink_info[5]
       if not test $sink_id = $default_sink_id -o $sink_id = $SOUND_PREV
           set new_default_sink_id $sink_id
           set new_default_sink_name $sink_name
       end
    end

    set --universal SOUND_PREV $default_sink_id

    # If the output we switch to is not set as default then the
    # system volume slider controls will not affect it.
    pactl set-default-sink $new_default_sink_id

    set inputs (pactl list short sink-inputs)
    for input in $inputs
        set input_id (string split \t $input)[1]
        pactl move-sink-input $input_id $new_default_sink_id
    end

    # set env var so that can use in i3status-rust
    set --universal SOUND_SOURCE (get_icon $new_default_sink_name)
    notify-send (string join " " "Switched to" $new_default_sink_name) --icon=audio-volume-high
end
