function increase-tmp
  set_color --bold brmagenta
  echo "Running command: sudo mount -o remount,size=7G,noatime /tmp"
  set_color normal
  echo "Current size: "
  df --human-readable --output='size,target' --block-size=M | grep /tmp
  sudo mount -o remount,size=7G,noatime /tmp
  echo "New size: "
  df --human-readable --output='size,target' --block-size=M | grep /tmp
end
