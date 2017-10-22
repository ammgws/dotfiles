function switchaudio --description 'Switch between audio outputs (assuming there are only 2)'
    # TODO: handle case when nothing is playing (both sinks are SUSPENDED)
    function set_output_name
        set sink_raw_name $argv
        if string match --quiet '*Pebbles*' $sink_raw_name
            set --global sink_name "speakers"
        else if string match --quiet '*pci*' $sink_raw_name
            set --global sink_name "headphones"
        else
            set --global sink_name $sink_raw_name
        end
    end

    # set current_default (pacmd stat | awk -F": " '/^Default sink name: /{print $2}')
    set current_default_raw (pacmd stat | string match "Default sink name: *" | string replace "Default sink name: " "")

    set sinks (pactl list short sinks)
    for sink in $sinks
       set sink_info (string split \t $sink)
       set sink_id $sink_info[1]
       set_output_name $sink_info[2]
       set sink_state $sink_info[5]

       if test $sink_info[2] = $current_default_raw
           set current_default_id $sink_id
           set current_default_name $sink_name
       else
           set switch_to_default_id $sink_id
           set switch_to_default_name $sink_name
       end

       switch $sink_state
           case RUNNING
               set active_sink $sink_id
           case SUSPENDED
               set inactive_sink $sink_id
           case IDLE
               set inactive_sink $sink_id
       end
    end

    # If the output we switch to is not set as default then the
    # system volume slider controls will not affect it.
    pactl set-default-sink $inactive_sink

    set inputs (pactl list short sink-inputs)
    for input in $inputs
        set input_id (string split \t $input)[1]
        pactl move-sink-input $input_id $inactive_sink
    end

    notify-send (string join " " "Switched to" $switch_to_default_name) --icon=audio-volume-high
end
