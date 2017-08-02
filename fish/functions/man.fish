function man --description "Colourisation and other customisations for manpages"
    # Note this works because `man` uses `less` for displaying pages,
    # which in turn uses `ncurses`, which uses `terminfo` terminal database
    # (replaced `termcap`). Colours are achieved via the below env vars
    # which are read by `less` when run (called "appearance modes").
    # For colour values refer to 256-colour lookup table: https://en.wikipedia.org/wiki/ANSI_escape_code
    # More info: https://unix.stackexchange.com/a/108840
    # https://www.gnu.org/software/termutils/manual/termcap-1.3/html_chapter/termcap_4.html#SEC33
    # http://linux.101hacks.com/ps1-examples/prompt-color-using-tput/
    set -lx LESS_TERMCAP_md (tput bold; tput setaf 39)  # enter bold mode, blue text
    set -lx LESS_TERMCAP_us (tput smul; tput setaf 40)  # enter underline mode, green text
    set -lx LESS_TERMCAP_ue (tput rmul; tput sgr0)  # leave underline mode
    set -lx LESS_TERMCAP_so (tput smso; tput setab 127)  # enter standout/reverse mode, purple bg
    set -lx LESS_TERMCAP_se (tput rmso; tput sgr0)  # leave standout/reverse mode
    set -lx LESS_TERMCAP_mh (tput dim)  # enter half-bright mode
    set -lx LESS_TERMCAP_me (tput sgr0)  # turns off all modes

    # To see raw manpage formatting (useful for deciding what colours to use above)
    # If it has worked manpage will have formatting like: <md>NAME<me> etc
    # set -lx LESS_TERMCAP_DEBUG 1

    # Get percentage to show without manually going to end of manpage
    # by passing +Gg to `less` (starts at end of page then moves to start).
    # More info: https://stackoverflow.com/a/19871578
    set -lx MANPAGER 'less -s -M +Gg'

    command man "$argv"
end
