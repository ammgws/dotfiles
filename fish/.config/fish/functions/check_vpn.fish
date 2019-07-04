function check_vpn --description="Return true if connected to VPN"
  argparse --name check_vpn 'h/help' 'b/barmode' -- $argv
  or return 1  # error

  function print_help
    echo "Usage: check_vpn [options]"
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

  set val (curl --silent https://am.i.mullvad.net/json | jq '.mullvad_exit_ip')
  if test $MODE = bar
    if test $val = true
      printf "<span color='green'>VPN</span>"
    else
      printf "<span color='red' strikethrough='true'>VPN</span>"
    end
  else
    if test $val = true
      return 0
    else
      return 1
    end
  end
end
