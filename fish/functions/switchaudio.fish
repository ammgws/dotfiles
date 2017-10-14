function switchaudio --description 'Switch between audio outputs'
    set -l sinks (pactl list short sinks)
    for sink in $sinks
       set sink_info (string split \t $sink)
       if test RUNNING = $sink_info[5]
           set active_sink $sink_info[1]
       else if test SUSPENDED = $sink_info[5]
           set inactive_sink $sink_info[1]
       end
    end

    echo $active_sink
    echo $inactive_sink

    set -l inputs (string split \t (pactl list short sink-inputs))
end
