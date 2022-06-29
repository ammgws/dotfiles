function ibus-toggle --description="Switches between IBus input methods and displays notification."
    # On first startup the first call fails with 'no global engine',
    # so just set it to EN.
    set engine (ibus engine 2>/dev/null)
    if test $status -ne 0
        ibus engine xkb:us::eng
        return 0
    end
    if test "$engine" = mozc-jp
        ibus engine xkb:us::eng
    else
        ibus engine mozc-jp
    end
end
