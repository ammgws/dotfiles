function upgrade-aur
  set_color --bold brmagenta
  echo "Running command: trizen --sync --refresh --sysupgrade --devel"
  set_color normal
  command pikaur --sync --refresh --sysupgrade
end
