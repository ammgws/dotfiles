function upgrade-aur
  set_color --bold brmagenta
  echo "Running command: pikaur --sync --refresh --sysupgrade --devel"
  set_color normal
  command pikaur --sync --refresh --sysupgrade --devel --needed
end
