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
        echo (set_color green)"-v<size> --volume=<size>"(set_color $fish_color_normal)": Set split volume size for 7z"
        echo (set_color green)"--randomize"(set_color $fish_color_normal)": Randomize output filename"
    end

    # default values for optional arguments
    set DEBUG 0
    set RANDOMIZE 0
    set SIZE 9M

    set shortopt --options h,d,v:

    # Only enable longoptions if GNU enhanced getopt is available
    getopt --test >/dev/null
    if test $status -eq 4
        # don't put a space after commas!
        set longopt --longoptions help,debug,randomize,volume:
    else
        set longopt
    end

    if not getopt --name ytmail --quiet-output $shortopt $longopt -- $argv >/dev/null
        return 1
    end

    set tmp (getopt $shortopt $longopt -- $argv)
    eval set opt $tmp
    # eval used here to unquote strings and turn string into array

    set num_opts 0
    while count $opt >/dev/null
        switch $opt[1]
            case -h --help
                print_help
                return 0

            case -d --debug
                set DEBUG 1
                echo "Debug on."
                set num_opts (math $num_opts + 1)

            case -v --volume
                set num_opts (math $num_opts + 1)
                if test -n $opt[2]
                    set SIZE $opt[2]
                else
                    print_help
                    return 1
                end

            case --randomize
                set RANDOMIZE 1
                set num_opts (math $num_opts + 1)

            case --
                set --erase opt[1]
                break
        end
        set --erase opt[1]
    end

    if test (math (count $argv) - $num_opts) -lt 2
        echo missing required arguments
        print_help
        return 2
    end

    set --local URL $argv[(math $num_opts + 1)]
    set --local RECIPIENT $argv[(math $num_opts + 2)]

    set --local OUTPUT_DIR (mktemp --directory)

    set --local RANDOM_NAME (cat /dev/random | tr --delete --complement 'a-zA-Z0-9' | fold --width 16 | head --lines 1)
    if test $RANDOMIZE = 1
        set --local EXTENSION (youtube-dl --get-filename --output '%(ext)s' $URL)
        set VIDEO_FILEPATH $OUTPUT_DIR/$RANDOM_NAME.$EXTENSION
    else
        set VIDEO_FILEPATH $OUTPUT_DIR/(youtube-dl --get-filename $URL)
    end
    youtube-dl --output $VIDEO_FILEPATH $URL

    if test -e $VIDEO_FILEPATH
        7z a -v$SIZE $OUTPUT_DIR/$RANDOM_NAME.7z $VIDEO_FILEPATH >/dev/null
    else
        echo "Video download failed"
        return 1
    end

    if test $status -eq 0
        for file in $OUTPUT_DIR/$RANDOM_NAME.7z.*
            echo $file
        end
    else
        echo "7z stage failed"
        return 1
    end
end
