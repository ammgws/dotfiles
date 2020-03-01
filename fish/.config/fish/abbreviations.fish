# Abbreviations (text expansion)
# After adding a new entry, run `set --erase fish_initialized` and restart fish.
abbr --add cf '$EDITOR $XDG_CONFIG_HOME/'
abbr --add cp 'cp --interactive --verbose'
abbr --add gdb 'gdb -nh -x "$XDG_CONFIG_HOME"/gdb/init'
abbr --add gp 'git push'
abbr --add gpf 'git push --force'
abbr --add gst 'git status'  # gs taken by Ghostscript
abbr --add icat 'kitty +kitten icat'
abbr --add ln 'ln --interactive --verbose'
abbr --add mv 'mv --interactive --verbose'
abbr --add pacin 'sudo pacman --sync --refresh --sysupgrade'
abbr --add pacrm 'sudo pacman --remove --recursive'
abbr --add pikin 'pikaur --sync --refresh --sysupgrade'
abbr --add uparch 'sudo pacman --sync --refresh --sysupgrade; and fish_update_completions'
abbr --add upaur 'pikaur --sync --refresh --sysupgrade --devel --needed --noconfirm; and fish_update_completions'
abbr --add send2phone 'kdeconnect-cli --device (kdeconnect-cli --list-available --id-only) --share $PWD/(fzf)'
abbr --add ytdl 'youtube-dl'
