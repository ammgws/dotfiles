function startw --description 'startx equivalent for starting sway'
    systemctl --user import-environment DISPLAY XAUTHORITY
    dbus-update-activation-environment DISPLAY XAUTHORITY

    # Encourage programs to use Wayland
    # see: https://github.com/swaywm/sway/wiki/Running-programs-natively-under-wayland
    set --export BEMENU_BACKEND wayland
    set --export CLUTTER_BACKEND wayland

    # GTK3+ will default to Wayland, so do not set otherwise it will break some apps.
    #set --export GDK_BACKEND wayland

    # https://www.enlightenment.org/about-wayland
    set --export ECORE_EVAS_ENGINE wayland_egl
    set --export ELM_ENGINE wayland_egl
    set --export _JAVA_AWT_WM_NONREPARENTING 1
    set --export MOZ_ENABLE_WAYLAND 1
    set --export MOZ_WAYLAND_USE_VAAPI 1
    # make sure qt5-wayland/qt6-wayland are installed as well:
    set --export QT_QPA_PLATFORM wayland
    set --export QT_WAYLAND_DISABLE_WINDOWDECORATION 1

    # Setting this was preventing Stardew Valley from running
    #set --export SDL_VIDEODRIVER wayland

    # Some programs might (wrongly?) look for this var
    # https://github.com/swaywm/sway/pull/4876
    # However Unity might be better for some apps with tray icons?
    # https://www.reddit.com/r/swaywm/comments/gekpeq/waybar_for_a_functional_tray_install/fpv3i1y/
    if status is-interactive
        and string length --quiet SWAYSOCK
        set --export XDG_CURRENT_DESKTOP sway
    end

    # For setting Qt5 theme
    # See https://wiki.archlinux.org/index.php/Qt#Configuration_of_Qt5_apps_under_environments_other_than_KDE_Plasma
    # TODO: change to qt6ct?
    set --export QT_QPA_PLATFORMTHEME qt5ct

    # For GTK3/4 applications. However some may still ignore this and thus need gsettings.
    set --export GTK_THEME Nordic
    # For GTK applications, import GTK2/3 settings:
    # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
    import-gsettings

    sway $argv
end
