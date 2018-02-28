function ibus-toggle --description="Switches between IBus input methods and displays notification."
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
