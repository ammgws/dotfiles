function upgrade-aur
  set_color --bold brmagenta
  echo "Running command: trizen --sync --refresh --sysupgrade"
  set_color normal
  command trizen --sync --refresh --sysupgrade
end
