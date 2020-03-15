# Abbreviations (text expansion)
# After adding a new entry, run `set --erase fish_initialized` and restart fish.
abbr --add cf '$EDITOR $XDG_CONFIG_HOME/'
abbr --add cleanup 'paccache --cachedir ~/.cache/pikaur/pkg -vrk0; or paccache -rvk0; and pikaur -Scc'
abbr --add cp 'cp --interactive --verbose'
abbr --add e micro
abbr --add gco 'git switch'
abbr --add gconq 'git switch -c'
abbr --add gdb 'gdb -nh -x "$XDG_CONFIG_HOME"/gdb/init'
abbr --add gp 'git push'
abbr --add gpf 'git push --force'
abbr --add gst 'git status' # gs taken by Ghostscript
abbr --add icat 'kitty +kitten icat'
abbr --add ln 'ln --interactive --verbose'
abbr --add mv 'mv --interactive --verbose'
abbr --add nano micro
abbr --add pacin 'sudo pacman --sync --refresh --sysupgrade'
abbr --add pacrm 'sudo pacman --remove --recursive'
abbr --add pikin 'pikaur --sync --refresh --sysupgrade'
abbr --add upall 'pikaur --sync --refresh --sysupgrade --devel --needed --noconfirm; and fish_update_completions; and fisher'
abbr --add uparch 'sudo pacman --sync --refresh --sysupgrade; and fish_update_completions'
abbr --add upaur 'pikaur --sync --refresh --sysupgrade --devel --needed --noconfirm; and fish_update_completions'
abbr --add send2phone 'kdeconnect-cli --device (kdeconnect-cli --list-available --id-only) --share $PWD/(fzf)'
abbr --add ytdl youtube-dl
