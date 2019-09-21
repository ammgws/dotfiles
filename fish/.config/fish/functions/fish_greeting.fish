function fish_greeting
  # Why not... only running greetings on remote sessions anyway.
  sl -l | lolcat
  clear
  set msg (string join "\n" "Welcome "(whoami)"." \
    (uname --machine --kernel-release --kernel-name) \
    (uptime --pretty))
  echo -e $msg | ponysay
  #fortune | ponysay
end
