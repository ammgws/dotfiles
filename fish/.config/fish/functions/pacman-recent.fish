function pacman-recent --description="Show recently upgraded/installed packages"
    argparse --name pacman-recent 'n/number=' 'p/packages=' -- $argv
    or return 1

    if set -lq _flag_number
        set number $_flag_number
    else
        set number 25
    end

    if set -lq _flag_packages
        set packages $_flag_packages
    end

    if string length --quiet $packages
        command tac /var/log/pacman.log | grep --ignore-case --extended-regexp 'installed|upgraded' | grep --extended-regexp (string replace ' ' '|' $packages) | head --lines=$number
    else
        command tac /var/log/pacman.log | grep --ignore-case --extended-regexp 'installed|upgraded' | head --lines=$number
    end
end
