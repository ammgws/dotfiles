function upgrade-pacman
  set_color --bold brmagenta
  echo "Running command: sudo pacman --sync --refresh --sysupgrade"
  set_color normal
  command sudo pacman --sync --refresh --sysupgrade
end
