function fish_greeting
  echo "Welcome "(whoami)"."
  uname --machine --kernel-release --kernel-name
  uptime --pretty
end
