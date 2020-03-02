function sway_lock
    ratbagctl warbling-mara led 0 set mode off
    swaylock
    ratbagctl warbling-mara led 0 set mode cycle
end
