function switchaudio --description 'Switch between audio outputs (assuming there are only 2)'
    set -l sinks (pactl list short sinks)
    for sink in $sinks
       set sink_info (string split \t $sink)
       set sink_id $sink_info[1]
       set sink_state $sink_info[5]

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

    set -l inputs (pactl list short sink-inputs)
    for input in $inputs
        set input_id (string split \t $input)[1]
        pactl move-sink-input $input_id $inactive_sink
    end
end
