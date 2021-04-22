function ibus-toggle --description="Switches between IBus input methods and displays notification."
    # On first startup the first call always seems to fail...
    set engine (ibus engine 2>/dev/null)
    set engine (ibus engine 2>/dev/null)
    if test $status -ne 0
        set msg "Failed to switch ibus engine"
        echo $msg
        notify-send "$msg" --icon=keyboard --expire-time=1000
        return 1
    end
    if test "$engine" = mozc-jp
        ibus engine xkb:us::eng
        set new_engine "English input"
    else
        ibus engine mozc-jp
        set new_engine "Japanese input (mozc)"
    end
    set msg "Switched to $new_engine"
    echo $msg
    notify-send "$msg" --icon=keyboard --expire-time=1000
end
