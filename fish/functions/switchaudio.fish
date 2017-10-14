function switchaudio --description 'Switch between audio outputs (assuming there are only 2)'
    set -l sinks (pactl list short sinks)
    for sink in $sinks
       set sink_info (string split \t $sink)
       if test RUNNING = $sink_info[5]
           set active_sink $sink_info[1]
       else if test SUSPENDED = $sink_info[5]
           set inactive_sink $sink_info[1]
       else if test IDLE = $sink_info[5]
           set inactive_sink $sink_info[1]
       end
    end

    set -l inputs (pactl list short sink-inputs)
    for input in $inputs
        set input_id (string split \t $input)[1]
        pactl move-sink-input $input_id $inactive_sink
    end
end
