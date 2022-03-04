function screenshot --description="Saves screenshot and also copies image to clipboard."
    set SCREENSHOT_DIR $SCREENSHOT_DIR

    # define colours to use when printing messages
    set cRed (set_color red)
    set cGrn (set_color green)
    set cBlu (set_color blue)
    set cRst (set_color $fish_color_normal)

    function print_help
        echo "Usage: screenshot [options]"
        echo "Options:"
        echo (set_color green)"-h"(set_color $fish_color_normal)": Prints this help"
    end

    # default values (that can be changed via args)
    set OUTPUT_MODE image
    set OPEN_URL 0
    set WM sway
    set DEPENDENCIES grim slurp wl-copy

    argparse --name screenshot h/help i-i3 -- $argv
    or return 1 #error

    if set -lq _flag_help
        print help
        return
    end

    if set -lq _flag_i3
        set DEPENDENCIES slop scrot xclip
        set WM i3
    end

    for dependency in $DEPENDENCIES
        if not type -q $dependency
            echo $cRed"You must have $dependency installed."$cRst
            return 1
        end
    end

    set FILENAME (string join "" $SCREENSHOT_DIR "/" (date +%Y%m%d_%Hh%Mm%Ss) ".png")

    if test $WM = sway
        # build locally until https://github.com/emersion/slurp/pull/95 is merged
        slurp -x -d | grim -g - $FILENAME
    else if test $WM = i3
        set FILENAME (scrot $FILENAME -q 100 -a -e 'echo $f')
    end

    if test $status -ne 0
        or not test -e $FILENAME
        return 1
    end

    if test $WM = i3
        xclip -selection clip -target image/png $FILENAME
    else
        wl-copy --type image/png <$FILENAME
    end
    notify-send Screenshot $FILENAME --icon=$FILENAME --expire-time=2000
end
