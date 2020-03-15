function screenshot --description="When using `sway`: Takes screenshot, uploads to Dropbox and copies link to clipboard."
    set SCREENSHOT_DIR $SCREENSHOT_DIR
    set WAIT_TIME 5
    set TIMEOUT 3

    # define colours to use when printing messages
    set cRed (set_color red)
    set cGrn (set_color green)
    set cBlu (set_color blue)
    set cRst (set_color $fish_color_normal)

    function print_help
        echo "Usage: screenshot [options]"
        echo "Options:"
        echo (set_color green)"-l"(set_color $fish_color_normal)": Only output URL to clipboard (default outputs image to clipboard and URL to primary)"
        echo (set_color green)"-o"(set_color $fish_color_normal)": Open URL in browser after upload"
    end

    # default values (that can be changed via args)
    set OUTPUT_MODE image
    set OPEN_URL 0
    set WM sway
    set DEPENDENCIES grim slurp wl-copy

    argparse --name screenshot h/help i-i3 l/linkonly o/openafter -- $argv
    or return 1 #error

    if set -lq _flag_help
        print help
        return
    end

    if set -lq _flag_i3
        set DEPENDENCIES slop scrot xclip
        set WM i3
    end

    if set -lq _flag_linkonly
        set OUTPUT_MODE linkonly
    end

    if set -lq _flag_openafter
        set OPEN_URL 1
    end

    set DEPENDENCIES $DEPENDENCIES dropbox-cli
    for dependency in $DEPENDENCIES
        if not type -q $dependency
            echo $cRed"You must have $dependency installed."$cRst
            return 1
        end
    end

    set FILENAME (string join "" $SCREENSHOT_DIR "/" (date +%Y%m%d_%Hh%Mm%Ss) ".png")

    if test $WM = sway
        slurp | grim -g - $FILENAME
    else if test $WM = i3
        set FILENAME (scrot $FILENAME -q 100 -a -e 'echo $f')
    end

    if test $status -ne 0
        or not test -e $FILENAME
        return 1
    end

    function getstatus
        set SYNC_STATUS (dropbox-cli filestatus $FILENAME)

        if test (string match $SYNC_STATUS = 'up to date')
            return 0
        else
            return 1
        end
    end

    getstatus
    set TIME_ELAPSED 0
    while test $status -eq 1; and test $TIME_ELAPSED -lt $TIMEOUT
        sleep 0.5
        set TIME_ELAPSED (math $TIME_ELAPSED + 1)
    end

    set DROPBOX_LINK (string join "" (dropbox-cli sharelink $FILENAME) "&raw=1")

    if test $OUTPUT_MODE = linkonly
        if test $WM = i3
            echo -n $DROPBOX_LINK | xclip -selection clip
        else
            echo -n $DROPBOX_LINK | wl-copy
        end
        notify-send Screenshot $DROPBOX_LINK --icon=$FILENAME --expire-time=2000
    else if test $OUTPUT_MODE = image
        if test $WM = i3
            xclip -selection clip -target image/png $FILENAME
            echo -n $DROPBOX_LINK | xclip -selection primary
        else
            wl-copy --type image/png <$FILENAME
        end
        notify-send Screenshot $FILENAME --icon=$FILENAME --expire-time=2000
    end

    if test $OPEN_URL = 1
        open $DROPBOX_LINK
    end

    sleep $WAIT_TIME
end
