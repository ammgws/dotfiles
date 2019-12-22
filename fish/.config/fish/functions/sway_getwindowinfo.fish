function sway_getwindow
  slurp -f "%x %y" | read x_sel y_sel
  for rect in (swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x) \(.width) \(.y) \(.height)"')
    echo $rect | read x1 w y1 h
    set x2 (math $x1 + $w)
    set y2 (math $y1 + $h)
    if test \( $x_sel -ge $x1 \) -a \( $x_sel -le $x2 \)
    and test \( $y_sel -ge $y1 \) -a \( $y_sel -le $y2 \)
      #swaymsg --type get_tree | jq ".. | objects | select(.rect.x == $x1 and .rect.y == $y1 and .rect.width == $w and .rect.height == $h) | .id, .name, .pid, .title, .app_id, .marks, .type"
      swaymsg --type get_tree | jq ".. | objects | select(.rect.x == $x1 and .rect.y == $y1 and .rect.width == $w and .rect.height == $h)"
    end
  end
end
