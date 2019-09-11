function check_xclients --description="Return number of current X clients"
  argparse --name check_xclients 'h/help' 'b/barmode' -- $argv
  or return 1  # error

  function print_help
    echo "Usage: check_xclients [options]"
    echo "Options:"
    echo (set_color green)"-b"(set_color $fish_color_normal)": Output text for i3status-rs bar"
  end

  if set -lq _flag_help
    print help
    return
  end

  set MODE std
  if set -lq _flag_barmode
    set MODE bar
  end

  set val (xlsclients | wc --lines)
  if test $MODE = bar
    if test val = 0
      printf "<span color='green'>X0</span>"
    else
      printf "<span color='red'>X$val</span>"
    end
  else
    echo $val
  end
end
