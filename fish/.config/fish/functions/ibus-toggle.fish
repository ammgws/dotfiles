function ibus-toggle
    set engine (ibus engine)
    if test $engine = "anthy"
        ibus engine xkb:us::eng
        set msg "English input"
    else
        ibus engine anthy
        set msg "Japanese input (Anthy)"
    end

    notify-send (string join " " "Switched to" $msg) --icon=keyboard
end
