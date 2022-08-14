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

if status is-login
    set --global __fish_git_prompt_use_informative_chars 1
    set --global __fish_git_prompt_showcolorhints 1
    set --global __fish_git_prompt_char_stateseparator ""

    # Encourage use of XDG Base Directory spec
    set --export XDG_CACHE_HOME ~/.cache
    set --export XDG_CONFIG_HOME ~/.config
    set --export XDG_DATA_HOME ~/.local/share
    set --export XDG_RUNTIME_DIR /run/user/(id -u)
    set --export CARGO_HOME $XDG_DATA_HOME/cargo
    set --export DVDCSS_CACHE $XDG_DATA_HOME/dvdcss
    set --export GTK2_RC_FILES $XDG_CONFIG_HOME/gtk-2.0/gtkrc
    set --export ICEAUTHORITY $XDG_RUNTIME_DIR/ICEauthority
    # ipython XDG support is iffy, just use the env overide
    set --export IPYTHONDIR $XDG_CONFIG_HOME/ipython
    set --export JUPYTER_CONFIG_DIR $XDG_CONFIG_HOME/jupyter
    set --export LESSHISTFILE $XDG_CACHE_HOME/less/history
    set --export LESSKEY $XDG_CONFIG_HOME/less/lesskey
    set --export RUSTUP_HOME $XDG_DATA_HOME/rustup
    set --export MPLAYER_HOME $XDG_CONFIG_HOME/mplayer
    set --export WEECHAT_HOME $XDG_CONFIG_HOME/weechat
    set --export WGETRC $XDG_CONFIG_HOME/wget/wgetrc
    set --export XAUTHORITY $XDG_RUNTIME_DIR/Xauthority
    set --export XINITRC $XDG_CONFIG_HOME/X11/xinitrc
    set --export VIRTUALFISH_HOME $XDG_DATA_HOME/virtualenvs

    # For Japanese IME support (fcitx code only looks for these)
    set --export GTK_IM_MODULE fcitx5
    set --export QT_IM_MODULE fcitx5
    set --export XMODIFIERS @im=fcitx5

    # Other
    # setting this doesnt seem to affect where android-studio offers to install the SDK,
    # but I gave it this path so will just leave this env for now in case needed by other stuff
    # Note: when installing SDK via aur, set to /opt/android-sdk
    set --export ANDROID_HOME $XDG_DATA_HOME/android-sdk
    set --export ANDROID_USER_HOME $XDG_CONFIG_HOME/android-tools
    set --export ANDROID_AVD_HOME $XDG_DATA_HOME/android-avd
    # create dir otherwise it keeps using fallback dir without emitting any warning
    if not test -d "$ANDROID_AVD_HOME"
        mkdir "$ANDROID_AVD_HOME"
    end
    
    set --export BROWSER /usr/bin/firefox
    set --export EDITOR micro
    set --export FZF_DEFAULT_COMMAND "fd --type f"
    set --export GIT_EDITOR micro
    set --export MANPAGER "fish --command 'col --no-backspaces --spaces | bat --language man --plain'" # use bat to colourise man
    set --export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS 0 # for when playing games
    set --export SHELL /usr/bin/fish
    set --export TERMINAL foot
    set --export VDPAU_DRIVER radeonsi # keeps trying to use nvidia driver
    set --export XKB_DEFAULT_LAYOUT us

    # Used in my fish functions
    set --export SCREENSHOT_DIR $HOME/Screenshots
end

if status is-interactive
    # gpg-agent manpage: always add this to whatever init file is used for all shell invocations
    set --export GPG_TTY (tty)

    # Make ssh use gpg-agent instad of ssh-agent
    if status is-login
        set --erase SSH_AGENT_PID
        if not set --query gnupg_SSH_AUTH_SOCK_by
            or test $gnupg_SSH_AUTH_SOCK_by -ne $fish_pid
            set --export SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
        end
        #dbus-update-activation-environment --systemd SSH_AUTH_SOCK
    end

    # gpg-agent manpage: Since the ssh-agent protocol does not contain a mechanism for telling the agent on which
    # display/terminal it is running, gpg-agent’s ssh-support will use the TTY or X display where gpg-agent has
    # been started. To switch this display to the current one, the following command may be used:
    gpg-connect-agent updatestartuptty /bye >/dev/null
end

if status is-interactive
    # User experience improvements over SSH
    if set --query SSH_CLIENT
        set --erase BROWSER

        # Make pinentry wrapper use terminal friendly pinentry program
        set --export PINENTRY_USER_DATA shell

        if ! set --query XDG_RUNTIME_DIR
            set --export XDG_RUNTIME_DIR /run/user/(id -u)
        end

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
end
