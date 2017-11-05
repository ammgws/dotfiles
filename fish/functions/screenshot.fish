function screenshot --description="Takes screenshot, uploads to Dropbox and copies link to clipboard."
    # set screenshot directory using env var
    set SCREENSHOT_DIR $SCREENSHOT_DIR
    set WAIT_TIME 5
    set TIMEOUT 3

    # define colours to use when printing messages
    set cRed (set_color red)
    set cGrn (set_color green)
    set cBlu (set_color blue)
    set cRst (set_color $fish_color_normal)

    set DEPENDENCIES xclip scrot dropbox-cli
    for dependency in $DEPENDENCIES
        if not type -q $dependency
            echo $cRed"You must have $dependency installed."$cRst
            return 1
        end
    end

    function print_help
        echo "Usage: screenshot [options]"
        echo "Options:"
        echo (set_color green)"-l"(set_color $fish_color_normal)": Output URL to clipboard (default outputs image to clipboard)"
        echo (set_color green)"-o"(set_color $fish_color_normal)": Open URL in browser after upload"
    end

    # default values for optional arguments
    set OUTPUT_MODE image
    set OPEN_URL 0

    set shortopt -o h,l,o

    # Only enable longoptions if GNU enhanced getopt is available
    getopt --test >/dev/null
    if test $status -eq 4
        # don't put a space after commas!
        set longopt --longoptions help,linkonly,openurl
    else
        set longopt
    end

    if not getopt --name screenshot -Q $shortopt $longopt -- $argv >/dev/null
        return 1  # error
    end

    set tmp (getopt $shortopt $longopt -- $argv)
    eval set opt $tmp

    while count $opt >/dev/null
        switch $opt[1]
            case -h --help
                print_help
                return 0

            case -l --linkonly
                set OUTPUT_MODE linkonly

            case -o --openafter
                set OPEN_URL 1

            case --
                set --erase opt[1]
                break
        end
        set --erase opt[1]
    end

    set FILENAME (string join "" $SCREENSHOT_DIR "/" (date +%Y%m%d_%Hh%Mm%Ss) ".png")
    set CROP_COORDS (slop)
    set FOCUSED_MONITOR (swaymsg --type get_workspaces | jq --raw-output '.[] | select(.focused == true) | .output')
    set RESOLUTION (swaymsg --type get_outputs | jq --arg name $FOCUSED_MONITOR '.[] | select(.name == $name) | .rect.width, .rect.height')
    swaygrab --raw | convert -flip -crop "$CROP_COORDS" -depth 8 -size $RESOLUTION[1]x$RESOLUTION[2] RGBA:- $FILENAME

    # or can do it like this if happy to use tempfile:
    #swaygrab /tmp/screenshot.png
    #convert /tmp/screenshot.png -crop "$CROP_COORDS" $FILENAME

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
    while test $status -eq 1; and test $TIME_ELAPSED -lt $TIMEOUT;
        sleep 0.5
        set TIME_ELAPSED (math $TIME_ELAPSED + 1)
    end

    set DROPBOX_LINK (string join "" (dropbox-cli sharelink $FILENAME) "&raw=1")

    if test $OUTPUT_MODE = "linkonly"
        echo -n $DROPBOX_LINK | xclip -sel clip
        notify-send "Screenshot" $DROPBOX_LINK --icon=$FILENAME
    else if test $OUTPUT_MODE = "image"
        xclip -sel clip -t image/png $FILENAME
        notify-send "Screenshot" $FILENAME --icon=$FILENAME
    end

    if test $OPEN_URL = 1
        open $DROPBOX_LINK
    end

    sleep $WAIT_TIME
end
