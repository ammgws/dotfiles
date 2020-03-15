function ytmail --description 'Download and email youtube videos. Useful for work since youtube is blocked.'
    function print_help
        echo "Usage: ytmail [options] URL RECIPIENT"
        echo "Options:"
        echo (set_color green)"-d --debug"(set_color $fish_color_normal)": Enable debug output"
        echo (set_color green)"-s<size> --split=<size>[B|K|M|G]"(set_color $fish_color_normal)": Set split volume size for 7z (default 9MB)."
    end

    set DEPENDENCIES $DEPENDENCIES youtube-dl gmailer_oauth
    for dependency in $DEPENDENCIES
        if not type -q $dependency
            echo (set_color red)"You must have $dependency installed."(set_color $fish_color_normal)
            return 1
        end
    end

    # default values for optional arguments
    set DEBUG 0
    set SIZE 9M

    argparse --name ytmail h/help d-debug 's-splitsize=' -- $argv
    or return 1 #error

    if set --local --query _flag_help
        print_help
        return
    end

    if set --local --query _flag_splitsize
        set SIZE $_flag_splitsize
    end

    set URL $argv[1]
    set RECIPIENT $argv[2]

    set RANDOM_STR (cat /dev/random | tr --delete --complement 'a-zA-Z0-9' | fold --width 16 | head --lines 1)
    set VIDEOID (youtube-dl --get-id $URL)
    set OUTPUT_DIR (mktemp --directory --tmpdir ytmail.XXXXXXXXXX)
    set ARCHIVE_FILEPATH $OUTPUT_DIR"/"$VIDEOID"_"$RANDOM_STR".sevenz" # avoid Google's annoying filter
    set VIDEO_FILEPATH $OUTPUT_DIR"/"(youtube-dl --get-filename --output "%(title)s.%(ext)s" $URL)

    echo (set_color green)"ytmail: Video file: $VIDEO_FILEPATH"(set_color $fish_color_normal)
    echo (set_color green)"ytmail: Archive file: $ARCHIVE_FILEPATH.*"(set_color $fish_color_normal)

    youtube-dl --recode-video mp4 --output $VIDEO_FILEPATH $URL

    if test -e $VIDEO_FILEPATH
        echo (set_color green)"ytmail: Found video file, creating archive now..."(set_color $fish_color_normal)
        7z a -v$SIZE $ARCHIVE_FILEPATH $VIDEO_FILEPATH >/dev/null
    else
        echo (set_color red)"ytmail: Video download failed. Abort."(set_color $fish_color_normal)
        return 1
    end

    if test $status -ne 0
        echo (set_color red)"ytmail: Archiving stage failed. Abort."(set_color $fish_color_normal)
        return 1
    end

    for file in $ARCHIVE_FILEPATH.*
        if test -e $file
            echo (set_color green)"ytmail: Archive found"(set_color $fish_color_normal)
            gmailer_oauth --attachment $file $RECIPIENT
        end
    end
end
