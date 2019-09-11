# WIP
function aur_update_count
    checkupdates && pikaur --query --sysupgrade --aur 2>/dev/null
end
