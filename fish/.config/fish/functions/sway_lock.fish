function sway_lock
    ratbagctl "Logitech G102 Prodigy Gaming Mouse" led 0 set mode off
    swaymsg --raw output '*' dpms off
    swaylock $argv
    ratbagctl "Logitech G102 Prodigy Gaming Mouse" led 0 set mode cycle
    swaymsg --raw output '*' dpms on
end
