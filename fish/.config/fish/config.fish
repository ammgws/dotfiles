set --export PATH /usr/local/bin $PATH

. ~/.config/fish/aliases.fish

eval (python -m virtualfish auto_activation)

set --export XKB_DEFAULT_LAYOUT us
set --export TERMINAL kitty
set --export BROWSER /usr/bin/firefox-nightly

# Encourage programs to use Wayland
# see: https://github.com/swaywm/sway/wiki/Running-programs-natively-under-wayland
set --export CLUTTER_BACKEND wayland
# GTK3+ will default to Wayland, so do not set otherwise it will break some apps.
#set --export GDK_BACKEND wayland
set --export MOZ_ENABLE_WAYLAND 1
set --export ECORE_EVAS_ENGINE wayland_egl
set --export ELM_ENGINE wayland_egl
set --export QT_QPA_PLATFORM wayland-egl
set --export QT_WAYLAND_DISABLE_WINDOWDECORATION 1
set --export SDL_VIDEODRIVER wayland
set --export _JAVA_AWT_WM_NONREPARENTING 1
set --export BEMENU_BACKEND wayland

# Encourage use of XDG dirs
set --export XDG_CACHE_HOME ~/.cache
set --export XDG_CONFIG_HOME ~/.config
set --export XDG_DATA_HOME ~/.local/share
set --export XDG_RUNTIME_DIR /run/user/(id -u)
set --export DVDCSS_CACHE $XDG_DATA_HOME/dvdcss
set --export GNUPGHOME $XDG_CONFIG_HOME/gnupg
set --export ICEAUTHORITY $XDG_RUNTIME_DIR/ICEauthority
set --export LESSHISTFILE $XDG_CACHE_HOME/less/history
set --export LESSKEY $XDG_CONFIG_HOME/less/lesskey
set --export MPLAYER_HOME $XDG_CONFIG_HOME/mplayer
set --export WGETRC $XDG_CONFIG_HOME/wget/wgetrc
set --export XAUTHORITY $XDG_RUNTIME_DIR/Xauthority
set --export XINITRC $XDG_CONFIG_HOME/X11/xinitrc

# For Japanese IME support
set --export GTK_IM_MODULE ibus
set --export QT_IM_MODULE ibus
set --export XMODIFIERS @im=ibus
set --export DefaultIMModule ibus

# User experience improvements over SSH
if set --query SSH_CLIENT
  if ! set --query XDG_RUNTIME_DIR
    set --export XDG_RUNTIME_DIR /run/user/(id -u)
  end

  set --export GPG_TTY (tty)

  if ! set --query DBUS_SESSION_BUS_ADDRESS -o test -z $DBUS_SESSION_ADDRESS
    set --local dbus_session_file $HOME/.dbus/session-bus/(cat /var/lib/dbus/machine-id)-0
    if test -e $dbus_session_file
      while read --local --array line
        set match (string match --regex "^DBUS_SESSION_BUS_ADDRESS=(.+)" $line)
        if test $status -eq 0
          set DBUS_SESSION_BUS_ADDRESS $match[2]
        end
      end < $dbus_session_file
    end
  end

  if ! set --query SWAYSOCK
    set --export SWAYSOCK /run/user/(id -u)/sway-ipc.(id -u)/(pidof sway).sock
  end

  # easier to use on phone
  set ip (string match --regex "(\d+.\d+.\d+.\d)" $SSH_CONNECTION)[2]
  if test $ip = 10.8.7.2
    set GIT_EDITOR nano
  end
end

# Abbreviations (text expansion)
abbr --add gp 'git push'
abbr --add gst 'git status'  # gs taken by Ghostscript
#abbr --add mv 'smv'

# Other
set --export FZF_DEFAULT_COMMAND "fd --type f"
set --export MOZ_WEBRENDER 1
set --export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS 0

# Used in my fish functions
set --export AMMCON_URL https://ammcon:port
set --export SCREENSHOT_DIR $HOME/Dropbox/screenshots
