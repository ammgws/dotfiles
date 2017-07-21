function gpg_encrypt --description 'GPG encrypt a file or folder'
    # TODO: change getopt to argparse when fish 2.7.0 is released, 
    #       option to upload to Dropbox/Gmail, 
    #       check that 7z completed successfully,
    #       look into gpg's --use-embedded-filename option,
    #       write zipped files to /tmp instead
    #
    # NOTE: option flags must be specified separately
    #       e.g. -p -z not -pz

    # set this to your key if you wish to include yourself as a recipient
    # TODO: let this be passed via the -s flag
    set YOUR_KEY yourkeynamehere

    # define colours to use when printing messages
    set cRed (set_color red)
    set cGrn (set_color green)
    set cBlu (set_color blue)    
    set cRst (set_color $fish_color_normal)
      
    function print_help
        echo "Usage: gpg_encrypt [options] INPUT RECIPIENT"
        echo "Options:"
        echo (set_color green)"-d --debug"(set_color $fish_color_normal)": Enable debug output"
        echo (set_color green)"-p --relative"(set_color $fish_color_normal)": Save output relative to input file"
        echo (set_color green)"-s --self"(set_color $fish_color_normal)": Include yourself as a recipient"
        echo (set_color green)"-z --randomize"(set_color $fish_color_normal)": Randomize output filename"
    end

    # default values for optional arguments
    set DEBUG 0
    set USE_RELATIVE 0
    set USE_RANDOM 0
    set SELF 0

    set -l shortopt -o hdpsz
    # don't put a space after commas!
    set -l longopt -l help,debug,relative,self,randomize

    if getopt -T >/dev/null
        set longopt
    end

    if not getopt -n gpg_encrypt -Q $shortopt $longopt -- $argv >/dev/null
        return 1  # error
    end

    set -l tmp (getopt $shortopt $longopt -- $argv)

    eval set opt $tmp

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

            case -p --relative
                set USE_RELATIVE 1
                set num_opts (math $num_opts + 1)

            case -s --self
                set SELF 1
                set num_opts (math $num_opts + 1)

            case -z --randomize
                set USE_RANDOM 1
                set num_opts (math $num_opts + 1)

            case --
                set -e opt[1]
                break

            case '-*'
                echo "unknown option: $opt[1]"
                print_help
                return 1  # error
        end

        set -e opt[1]
    end

    if test (math (count $argv) - $num_opts) -lt 2
        print_help
        return 2  # missing required arguments
    end

    set INPUT_FILE $argv[(math $num_opts + 1)]
    set RECIPIENT $argv[(math $num_opts + 2)]

    if test -f $INPUT_FILE
        if test $DEBUG = 1; echo "Input is a file"; end 
        set IS_DIR 0
    end
    if test -d $INPUT_FILE
        if test $DEBUG = 1; echo "Input is a folder"; end 
        set IS_DIR 1
    end
    
    if test $USE_RELATIVE = 1
        set OUTPUT_DIR (dirname $INPUT_FILE)
    else
        set OUTPUT_DIR (pwd)
    end

    set -l FILENAME (basename $INPUT_FILE) 
    if test $USE_RANDOM = 1
        set FILENAME (cat /dev/random | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
    end

    set -l OUTPUT_FILENAME (string join "" (date +'%Y%m%d_%Hh%Mm%Ss_') $FILENAME)
    set -l OUTPUT_FILEPATH (string join "/" $OUTPUT_DIR $OUTPUT_FILENAME)

    if test $IS_DIR = 1
        set -l OUTPUT_ZIP (string join "" $FILENAME.7z)
        7z a $OUTPUT_ZIP $INPUT_FILE >/dev/null
        set INPUT_FILE $OUTPUT_ZIP
    end

    if test $SELF = 1
        gpg --quiet -esa -r $YOUR_KEY -r $RECIPIENT --output $OUTPUT_FILEPATH $INPUT_FILE
    else
        gpg --quiet -esa -r $RECIPIENT --output $OUTPUT_FILEPATH $INPUT_FILE
    end
    
    if test $status -eq 0    
        echo $OUTPUT_FILEPATH

        if test $IS_DIR = 1  
            rm -i $INPUT_FILE
        end
    end
end
