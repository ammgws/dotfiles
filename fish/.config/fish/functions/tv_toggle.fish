#TODO: Make it generic (not just tv - accept arg for output to toggle)
#filter by make, model, serial
function tv_toggle --description="Toggle output status (enable/disable)."
  set --local tv_status (swaymsg -t get_outputs | jq --raw-output '.. | objects | select(.model == "LG TV") | .active')
  if test $tv_status = "true"
    swaymsg output HDMI-A-2 disable
  else
    swaymsg output HDMI-A-2 enable
  end
end
