function tv_status
  set -l current_outputs (swaymsg --raw --type get_outputs | jq --raw-output '.[] | [.model, .active] | @csv')
  for output in $current_outputs
    set -l data (string split ',' $output)
    set -l name (string unescape $data[1])
    set -l active $data[2]
    if test $name = "LG TV" -a $active = "true"
      printf "<span color='green'>📺ON</span>"
    else if test $name = "LG TV" -a $active = "false"
      printf "<span color='green'>📺OFF</span>"
    end
  end
end
