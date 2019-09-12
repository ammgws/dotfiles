function import-gsettings
  function gset --argument-names key val
    gsettings set org.gnome.desktop.interface $key $val
  end

  while read --local --array line
    set config (string match --regex "(gtk-[\w|-]+)\s*=\s*(.+)" $line)
    if string match --quiet $config[2] gtk-theme-name
      gset gtk-theme $config[3]
    else if string match --quiet $config[2] gtk-icon-theme
      gset icon-theme $config[3]
    else if string match --quiet $config[2] gtk-cursor-theme
      gset cursor-theme $config[3]
    #TODO: figure out why this is not capturing the whole string 'Roboto 10'
    #else if string match --quiet $config[2] gtk-font-name
    #  gset font-name $config[3]
    end
  end < ~/.config/gtk-3.0/settings.ini
end
