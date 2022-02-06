# Disconnects bluetooth controller once a game is closed, in order to save battery.
#
# Assumptions:
# - game is started by Steam
# - game is running through xwayland
#   (from limiting testing native games do not seem to have any reliable identifiers)
#
# TODO: check parent pid of the container that was closed, and if it was steam then
#       we could assume it was a game? might work for native games as well..
function sway_disconnect_controller --argument controller_mac_address
    swaymsg --type subscribe "['window']" --monitor | while read --local line
        string length --quiet "$line"
        or continue

        set event_type (echo $line | jq --raw-output '.change')
        string match --quiet close -- $event_type
        or continue

        set class_name (echo $line | jq --raw-output '.container | .window_properties | .class')
        string match 'steam_app_*' -- "$class_name"
        or continue

        echo "Disconnecting controller!"
        bluetoothctl disconnect "$controller_mac_address" &
    end
