function sway_lock
    ratbagctl "Logitech G102 Prodigy Gaming Mouse" led 0 set mode off
    swaylock
    ratbagctl "Logitech G102 Prodigy Gaming Mouse" led 0 set mode cycle
end
