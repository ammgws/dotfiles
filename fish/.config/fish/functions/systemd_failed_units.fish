function systemd_failed_units
    set raw (systemctl --user --failed | wc --lines)
    set nfailed (math $raw-2)
    if test $nfailed -gt 0
        printf "check systemd"
    else
        printf ""
    end
end
