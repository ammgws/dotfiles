if status is-login
    contains /usr/local/bin $PATH
    or set PATH /usr/local/bin $PATH
    contains ~/.local/bin $PATH
    or set PATH ~/.local/bin $PATH
    contains ~/.cargo/bin $PATH
    or set PATH ~/.cargo/bin $PATH
end

if status is-interactive
    . ~/.config/fish/aliases.fish
end

# Universal vars only need to be set once.
# After adding a new var, run set --erase fish_initialized and restart fish.
if status is-interactive
    and not set --query fish_initialized
    . ~/.config/fish/abbreviations.fish # abbr uses universal vars
    set --universal __done_exclude 'git|firefox-nightly|micro|nano|vim|vi'
    set --universal __done_sway_ignore_visible 1
    set --universal fish_initialized
end

# Encourage use of XDG Base Directory spec
set --export XDG_CACHE_HOME ~/.cache
set --export XDG_CONFIG_HOME ~/.config
set --export XDG_DATA_HOME ~/.local/share
set --export XDG_RUNTIME_DIR /run/user/(id -u)
set --export CARGO_HOME $XDG_DATA_HOME/cargo
set --export DVDCSS_CACHE $XDG_DATA_HOME/dvdcss
set --export GNUPGHOME $XDG_CONFIG_HOME/gnupg
set --export ICEAUTHORITY $XDG_RUNTIME_DIR/ICEauthority
set --export LESSHISTFILE $XDG_CACHE_HOME/less/history
set --export LESSKEY $XDG_CONFIG_HOME/less/lesskey
set --export MPLAYER_HOME $XDG_CONFIG_HOME/mplayer
set --export WEECHAT_HOME $XDG_CONFIG_HOME/weechat
set --export WGETRC $XDG_CONFIG_HOME/wget/wgetrc
set --export XAUTHORITY $XDG_RUNTIME_DIR/Xauthority
set --export XINITRC $XDG_CONFIG_HOME/X11/xinitrc

# For Japanese IME support
set --export GTK_IM_MODULE ibus
set --export QT_IM_MODULE ibus
set --export XMODIFIERS @im=ibus
set --export DefaultIMModule ibus

# Other
set --export BROWSER /usr/bin/firefox-nightly
set --export EDITOR micro
set --export FZF_DEFAULT_COMMAND "fd --type f"
set --export GIT_EDITOR micro
set --export MANPAGER "fish --command 'col --no-backspaces --spaces | bat --language man --plain'" # use bat to colourise man
set --export MOZ_DBUS_REMOTE 1  # allows X11 and Wayland Firefox instances to run together
set --export MOZ_WEBRENDER 1
set --export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS 0 # for when playing games
set --export SHELL /usr/bin/fish
set --export TERMINAL kitty
set --export VDPAU_DRIVER radeonsi # keeps trying to use nvidia driver
set --export XKB_DEFAULT_LAYOUT us

# Used in my fish functions
set --export SCREENSHOT_DIR $HOME/Dropbox/screenshots

# User experience improvements over SSH
if set --query SSH_CLIENT
    set --erase BROWSER

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
                    set --export DBUS_SESSION_BUS_ADDRESS $match[2]
                end
            end <$dbus_session_file
        end
    end

    if ! set --query SWAYSOCK
        and pidof sway
        set --export SWAYSOCK /run/user/(id -u)/sway-ipc.(id -u).(pidof sway).sock
    end

    # Change editor when remoting in from phone
    set ip (string match --regex "(\d+.\d+.\d+.\d)" $SSH_CONNECTION)[2]
    if test "$ip" = "10.8.7.2"
        set --export GIT_EDITOR micro
        set --export EDITOR micro
    end
end

thefuck --alias | source
