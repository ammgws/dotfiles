#TODO: check if command succeeded
function ibus-toggle --description="Switches between IBus input methods and displays notification."
    set engine (ibus engine)
    if test $engine = "mozc-jp"
        ibus engine xkb:us::eng
        set msg "English input"
    else
        ibus engine mozc-jp
        set msg "Japanese input (mozc)"
    end

    notify-send (string join " " "Switched to" $msg) --icon=keyboard --expire-time=1000
end
