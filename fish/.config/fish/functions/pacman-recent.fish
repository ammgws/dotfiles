function pacman-recent --description="Show last 25 upgraded/installed packages"
    command tac /var/log/pacman.log | head -n 1000 | grep --ignore-case --extended-regexp 'installed|upgraded' | tail --lines=50
end
