. ~/.config/fish/aliases.fish

eval (python -m virtualfish auto_activation)

set -Ux XDG_CACHE_HOME ~/.cache
set -Ux XDG_CONFIG_HOME ~/.config
set -Ux XDG_DATA_HOME ~/.local/share
# seems to be set already (Arch Linux)
# set -Ux XDG_RUNTIME_DIR /run/user/1000

set -Ux DVDCSS_CACHE $XDG_DATA_HOME/dvdcss
set -Ux GNUPGHOME $XDG_CONFIG_HOME/gnupg
set -Ux ICEAUTHORITY $XDG_RUNTIME_DIR/ICEauthority
set -Ux LESSHISTFILE $XDG_CACHE_HOME/less/history
set -Ux LESSKEY $XDG_CONFIG_HOME/less/lesskey
set -Ux MPLAYER_HOME $XDG_CONFIG_HOME/mplayer
set -Ux XAUTHORITY $XDG_RUNTIME_DIR/Xauthority
