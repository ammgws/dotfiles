function videograb --description="Records video of screen selection in sway"
  # TODO: stop recording when recv SIGINT
  set --local record true
  function record_stop_handler --on-signal INT --no-scope-shadowing
    set record false
  end

  set TMPDIR (mktemp --directory)
  set CROP_COORDS (slop)
  set FOCUSED_MONITOR (swaymsg --type get_workspaces | \
                       jq --raw-output '.[] | select(.focused == true) | .output')
  set RESOLUTION (swaymsg --type get_outputs | \
                  jq --arg name $FOCUSED_MONITOR '.[] | select(.name == $name) | .rect.width, .rect.height')

  set num 1
  set delay 0.1
  set elapsed 0
  while test "$record" -a (math "$elapsed < 30") -eq 1
    swaygrab --raw | \
    convert -flip -crop "$CROP_COORDS" \
            -depth 8 \
            -size $RESOLUTION[1]x$RESOLUTION[2] \
            RGBA:- (string join "" $TMPDIR "/" $num ".png")
    set num (math $num+1)
    set elapsed (math $elapsed+$delay)
    sleep $delay
  end

  # TODO: handle int so we can actually get here on demand
  ffmpeg -loglevel quiet \
         -pattern_type glob \
         -i (string join "" $TMPDIR "/" "*.png") \
         (string join "" $SCREENSHOT_DIR "/gif" $TIME (date +%Y%m%d_%Hh%Mm%Ss) ".webm")
end
