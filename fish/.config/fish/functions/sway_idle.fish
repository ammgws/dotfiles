function sway_idle
# To make sure swayidle waits for swaylock to lock the screen before it releases the inhibition lock,
# swayidle's -w (wait) option and swaylock's -f/--daemonize options are used.
swayidle -d -w \
     timeout 300 'fish --command="sway_lock --debug 2>>/tmp/swaylock_timeout300.log"' \
     idlehint 300 \
     timeout 600 'swaymsg "output * dpms off"' \
          resume 'swaymsg "output * dpms on"' \
     before-sleep 'fish --command="sway_lock --debug 2>>/tmp/swaylock_beforesleep.log"' \
     2>>/tmp/swayidle.log
end