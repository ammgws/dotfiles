# Abbreviations (text expansion)
# After adding a new entry, run `set --erase fish_initialized` and restart fish.
abbr --add cat 'bat'
abbr --add cf '$EDITOR $XDG_CONFIG_HOME/'
abbr --add cleanup 'paccache -rvk0; yarn cache clean; cargo cache --autoclean; rm ~/.cache/electron/*; paru --remove --nosave --recursive (pacman --query --unrequired --deps --quiet)'
abbr --add cp 'cp --interactive --verbose'
abbr --add dd 'dd status=progress'
abbr --add e micro
abbr --add ga 'git add --patch'
abbr --add gcl 'git clone' # gc taken
abbr --add gco 'git switch'
abbr --add gcr 'git switch --create'
abbr --add gdb 'gdb -nh -x "$XDG_CONFIG_HOME"/gdb/init'
abbr --add gp 'git push'
abbr --add gpf 'git push --force'
abbr --add gst 'git status' # gs taken by Ghostscript
abbr --add tagdates "git tag -l --sort=-creatordate --format='%(creatordate:short):  %(refname:short)'"
abbr --add icat 'kitty +kitten icat'
abbr --add ln 'ln --interactive --verbose'
abbr --add mv 'mv --interactive --verbose'
abbr --add nano micro
abbr --add aurin 'paru --sync --refresh --sysupgrade'
abbr --add rebuildpyton 'pacman -Qoq /usr/lib/python3.9 | pacman -Qmq - | paru -S --rebuild -'
abbr --add pacin 'sudo pacman --sync --refresh --sysupgrade'
abbr --add pacrm 'sudo pacman --remove --recursive'
abbr --add paclargest "LC_ALL=C pacman --query --info | awk '/^Name/{name=\$3} /^Installed Size/{print \$4\$5, name}' | sort --human-numeric-sort"
abbr --add reinstallaur "for pkg in (pacman -Qm); paru --sync --refresh --skipreview --noconfirm (string replace --regex --filter '(.*)\s.*'  '\$1' -- \$pkg); end"
abbr --add rsync "rsync --progress"
abbr --add sclu 'systemctl --user'
abbr --add udm 'udiskie-mount --all'
abbr --add udu 'udiskie-umount --all'
abbr --add sclu 'systemctl --user'
abbr --add upall 'paru --sync --refresh --sysupgrade --devel --needed --noconfirm; and fish_update_completions; and fisher update'
abbr --add uparch 'sudo pacman --sync --refresh archlinux-keyring; and sudo pacman --sync --refresh --sysupgrade; and fish_update_completions'
abbr --add upaur 'sudo pacman --sync --refresh archlinux-keyring; and paru --sync --refresh --sysupgrade --devel --needed --noconfirm; and paru --sync --refresh wofi-hg; and fish_update_completions'
abbr --add send2phone 'kdeconnect-cli --device (kdeconnect-cli --list-available --id-only) --share $PWD/(fzf)'
abbr --add sway_install_git 'paru --sync --refresh wlroots-git; and paru --sync --refresh sway-git swayidle-git swaybg-git swaylock-git; and paru --sync --refresh swaynagmode'
abbr --add sway_remove_git 'sudo pacman --remove swaynagmode; and sudo pacman --remove --recursive wlroots-git sway-git swayidle-git swaybg-git swaylock-git'
abbr --add sway_install_release 'sudo pacman --sync --refresh --sysupgrade sway swayidle swaybg swaylock; and pikaur --sync --refresh swaynagmode'
abbr --add sway_remove_release 'sudo pacman --remove --recursive sway swayidle swaybg swaylock'
abbr --add ytdl youtube-dl
