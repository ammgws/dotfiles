function upgrade-aur
  set_color --bold brmagenta
  echo "Running command: pikaur --sync --refresh --sysupgrade --devel --needed --noconfirm" $argv
  set_color normal
  command pikaur --sync --refresh --sysupgrade --devel --needed --noconfirm $argv
end
