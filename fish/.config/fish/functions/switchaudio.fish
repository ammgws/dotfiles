function switchaudio --description 'Switch between audio devices and move all current audio outputs to the new device.'
  # model name of the TV. Can find via `swaymsg -t get_outputs` or `pactl list cards`
  set TV_MODEL_NAME "LG TV"

  function print_help
    echo "Usage: switchaudio [options]"
    echo "Options:"
    echo (set_color green)"-d/--device"(set_color $fish_color_normal)": Switch to the specified device."
    echo (set_color green)"-k/--keep"(set_color $fish_color_normal)": Switch audio device but leave current sinks alone."
    echo (set_color green)"-m/--menu"(set_color $fish_color_normal)": Display menu to choose from."
  end

  argparse --name switchaudio 'h/help' 'm/menu' 'k/keep' 'd/device=' -- $argv
  or return 1  #error

  if set -lq _flag_help
    print_help
    return
  end

  if set -lq _flag_device
    set device $_flag_device
  end

  if set -lq _flag_keep
    set keep_sinks 1
  end

  if set -lq _flag_menu
    set use_menu 1
  end

  function prettify_name --argument-names sink_raw_name
    if string match --quiet '*Pebbles*' $sink_raw_name
      echo "speakers"
    else if string match --quiet 'alsa_output.pci-0000_00_1b.0.analog-stereo' $sink_raw_name
      echo "headphones"
    else if string match --quiet '*PCH*' $sink_raw_name
      echo "headphones"
    else if string match --quiet 'bluez_sink*' $sink_raw_name
      echo "bluetooth"
    else if string match --quiet 'alsa_output.pci-0000_01_00.1.hdmi-stereo-extra*' $sink_raw_name
      echo "TV"
    else
      echo $sink_raw_name
    end
  end

  function get_icon --argument-names output_device
    if string match --quiet 'headphones' $output_device
      echo "🎧"
    else if string match --quiet 'speakers' $output_device
      echo "🔈"
    else if string match --quiet 'bluetooth' $output_device
      echo "BT"
    else if string match --quiet 'TV' $output_device
      echo "📺"
    else
      echo "??"
    end
  end

  function get_sink_volume --argument-names sink_id
    pacmd list-sinks | \
    grep --after-context=15 "index: $sink_id\$" | \
    grep 'volume:' | \
    grep --extended-regexp --invert-match 'base volume:' | \
    awk -F : '{print $3}' | \
    grep --only-matching --perl-regexp '.{0,3}%' | \
    sed 's/.$//' | \
    tr --delete ' '
  end

  set sinks (pactl list short sinks)

  if test $use_menu
      for sink in $sinks
        set sink_info (string split \t $sink)
        set sink_name (prettify_name $sink_info[2])
        set device_choices (string join "\n" $device_choices $sink_name)
      end
      set device (echo -e "$device_choices" | bemenu)
  end

  set default_sink_id (pacmd list-sinks | awk '/* index:/{print $3}')
  for sink in $sinks
    set sink_info (string split \t $sink)
    set sink_id $sink_info[1]
    set sink_name (prettify_name $sink_info[2])
    set sink_state $sink_info[5]
    if test -z $device
      if test (count $sinks) -le 2 -a "$sink_id" -ne "$default_sink_id"
        set new_default_sink_id $sink_id
        set new_default_sink_name $sink_name
      else
        if test "$sink_id" -ne "$default_sink_id" -a "$sink_id" -ne "$SOUND_PREV"
          set new_default_sink_id $sink_id
          set new_default_sink_name $sink_name
        end
      end
    else
      if test "$sink_name" = "$device"
        set new_default_sink_id $sink_id
        set new_default_sink_name $sink_name
      end
    end
  end

  if test -z $new_default_sink_id
    return 1  # couldn't find matching device
  end

  # If the output we switch to is not set as default then the
  # system volume slider controls will not affect it.
  pactl set-default-sink $new_default_sink_id
  set --universal SOUND_PREV $default_sink_id

  set new_sink_volume (get_sink_volume $default_sink_id)
  if test $new_sink_volume -gt 100
    set new_sink_volume 100
  end
  pactl set-sink-volume $new_default_sink_id "$new_sink_volume%"

  if not set --query keep_sinks
    set inputs (pactl list short sink-inputs)
    for input in $inputs
      set input_id (string split \t $input)[1]
      pactl move-sink-input $input_id $new_default_sink_id
    end
  end

  # For the TV, ensure the card profile is set to the correct HDMI port, otherwise we get no sound.
  if test $new_default_sink_name = "TV"
    # Get the first profile listed after "Part of profile(s):" for the HDMI port the TV is connected to.
    # Will probably be 'output:hdmi-stereo-extra*'. TODO: Will I ever want the non-stereo profiles?
    set TV_hdmi_port_profile (pactl list cards | \
      grep --after-context=100 "Name: alsa_card.pci-0000_01_00.1" | \
      sed '/Card/Q' | \
      grep --after-context=1 "$TV_MODEL_NAME" | \
      string match --regex '(output:hdmi-[^,]+)')[2]
    or return 1

    set active_profile (pactl list cards | \
                     grep --after-context=100 "Name: alsa_card.pci-0000_01_00.1" | \
                     sed '/Card/Q' | \
                     string match --regex 'Active Profile: (output:hdmi-.+)')[2]

    if test "$TV_hdmi_port_profile" != "$active_profile"
      pactl set-card-profile alsa_card.pci-0000_01_00.1 $TV_hdmi_port_profile
    end
  end

  qdbus localhost.statusbar.DBus \
        /localhost/statusbar/DBus/SoundDevice \
        org.freedesktop.DBus.Properties.Set \
        localhost.statusbar.DBus \
        Status (get_icon $new_default_sink_name)
  notify-send (string join " " "Switched to" $new_default_sink_name) --icon=audio-volume-high --expire-time=1000
end
