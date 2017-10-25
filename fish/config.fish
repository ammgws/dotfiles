. ~/.config/fish/aliases.fish

eval (python -m virtualfish auto_activation)

set --universal --export TERMINAL urxvt

set --universal --export XDG_CACHE_HOME ~/.cache
set --universal --export XDG_CONFIG_HOME ~/.config
set --universal --export XDG_DATA_HOME ~/.local/share
set --universal --export XDG_RUNTIME_DIR /run/user/(id -u)

set --universal --export DVDCSS_CACHE $XDG_DATA_HOME/dvdcss
set --universal --export GNUPGHOME $XDG_CONFIG_HOME/gnupg
set --universal --export ICEAUTHORITY $XDG_RUNTIME_DIR/ICEauthority
set --universal --export LESSHISTFILE $XDG_CACHE_HOME/less/history
set --universal --export LESSKEY $XDG_CONFIG_HOME/less/lesskey
set --universal --export MPLAYER_HOME $XDG_CONFIG_HOME/mplayer
set --universal --export WGETRC $XDG_CONFIG_HOME/wget/wgetrc
set --universal --export XAUTHORITY $XDG_RUNTIME_DIR/Xauthority
set --universal --export XINITRC $XDG_CONFIG_HOME/X11/xinitrc
