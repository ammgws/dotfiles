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
    else
        # no greeting
        set last_login_desktop (date --date (last -R (whoami) | awk '/still logged in/ {print $3,$4,$5,$6}' | head --lines=1) +%s)
        #echo $last_login_desktop
        set last_login_remote (date --date (last --nohostname --limit 1 (whoami) | awk '{print $3,$4,$5,$6}' | head --lines=1) +%s)
        #echo $last_login_remote
    end
end
