function fish_greeting
    if set --query SSH_CLIENT
        or status is-login
        and not set --query TMUX
        set msg (string join "\n" "Welcome "(whoami)@(hostname)"." \
      (uname --machine --kernel-release --kernel-name) \
      (uptime --pretty) \
      (systemd-analyze time)
    )
        echo -e $msg | cowsay
    end
end
