function ime_status
    set current_ime (ibus engine ^ /dev/null)
    if test -z $current_ime
        printf '%s' '??'
    else if test $current_ime = 'xkb:us::eng'
        printf '%s' 'EN'
    else if test "$current_ime" = 'anthy'
        printf '%s' 'JP'
    else if test "$current_ime" = 'mozc-jp'
        printf '%s' 'JP'
    else
        printf '%s' '??'
    end
end
