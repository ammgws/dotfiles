function ytmail --description 'Download and email youtube videos. Useful for work since youtube is blocked.'
    # define colours to use when printing messages
    set cRed (set_color red)
    set cGrn (set_color green)
    set cBlu (set_color blue)
    set cRst (set_color $fish_color_normal)

    function print_help
        echo "Usage: ytmail [options] URL RECIPIENT"
        echo "Options:"
        echo (set_color green)"-d --debug"(set_color $fish_color_normal)": Enable debug output"
        echo (set_color green)"-s<size> --splitsize=<size>"(set_color $fish_color_normal)": Set split volume size for 7z (default 9MB)"
    end

    set DEPENDENCIES $DEPENDENCIES youtube-dl gmailer_oauth
    for dependency in $DEPENDENCIES
        if not type -q $dependency
            echo $cRed"You must have $dependency installed."$cRst
            return 1
        end
    end

    # default values for optional arguments
    set DEBUG 0
    set RANDOMIZE 0
    set SIZE "9M"

    argparse --name screenshot 'h/help' 'd-debug' 's-splitsize' -- $argv
    or return 1  #error

    if set -lq _flag_help
        print help
        return
    end

    if set -lq _flag_splitsize
        set SIZE _flag_splitsize
    end

    set URL $argv[1]
    set RECIPIENT $argv[2]


    set RANDOM_STR (cat /dev/random | tr --delete --complement 'a-zA-Z0-9' | fold --width 16 | head --lines 1)
    set VIDEOID (youtube-dl --get-id $URL)
    set OUTPUT_DIR (mktemp --directory)
    set ARCHIVE_FILEPATH $OUTPUT_DIR"/"$VIDEOID"_"$RANDOM_STR".7z"
    set VIDEO_FILEPATH $OUTPUT_DIR"/"(youtube-dl --get-filename --output "%(title)s.%(ext)s" $URL)

    echo "Video file:" $VIDEO_FILEPATH
    echo "Archive file:" $ARCHIVE_FILEPATH".*"

    youtube-dl --recode-video "mp4" --output $VIDEO_FILEPATH $URL

    if test -e $VIDEO_FILEPATH
        echo "Found video file, creating archive now..."
        7z a -v$SIZE $ARCHIVE_FILEPATH $VIDEO_FILEPATH >/dev/null
    else
        echo "Video download failed. Abort."
        return 1
    end

    if test $status -eq 0
        echo "Archive found"
        for file in $ARCHIVE_FILEPATH.*
            gmailer_oauth --attachment $file $RECIPIENT
        end
    else
        echo "7z stage failed"
        return 1
    end
end
