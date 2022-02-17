# Blocks until the given sway container has appeared, and returns the container ID
function sway_wait_for_window --argument app_name
    swaymsg --type subscribe "['window']" --monitor | while read --local event
        string length --quiet "$event"
        or continue

        set event_type (echo $event | jq --raw-output '.change')
        # new = new instance has opened
        # focus, urgent = instance was already running, but is now focused
        # or tagged urgent on an inactive workspace
        set window_open_events new focus urgent
        contains $event_type $window_open_events
        or continue

        set xwayland_class (echo $event | jq --raw-output '.container | .window_properties | .class')
        set xdgshell_app_id (echo $event | jq --raw-output '.container | .app_id')
        string match --quiet "$app_name" -- "$xwayland_class"
        or string match --quiet "$app_name" -- "$xdgshell_app_id"
        or continue

        echo $event | jq --raw-output '.container | .id'
        break
    end
end
