function create_drive_image --description 'Create image of a disk using dd with progress updates'
    function print_help
        echo "Usage: create_drive_image [options] DRIVE"
        echo "Options:"
        echo (set_color green)"-d --debug"(set_color $fish_color_normal)": Enable debug output"
        echo (set_color green)"-o --output"(set_color $fish_color_normal)": Set output file"
    end

    # default values for optional arguments
    set DEBUG 0
    set OUTPUT_FILE (string join "" (mktemp) .img.gz)

    set -l shortopt --options h,d,o::

    # Only enable longoptions if GNU enhanced getopt is available
    getopt --test >/dev/null
    if test $status -eq 4
        # don't put a space after commas!
        set longopt --longoptions help,debug,output::
    else
        set longopt
    end

    if not getopt --name create_drive_image -Q $shortopt $longopt -- $argv >/dev/null
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

            case -o --output
                set num_opts (math $num_opts + 1)
                if test -n $opt[2]
                    set OUTPUT_FILE $opt[2]
                else
                    print_help
                    return 1
                end

            case --
                set -e opt[1]
                break
        end
        set -e opt[1]
    end

    if test (math (count $argv) - $num_opts) -lt 1
        print_help
        return 2  # missing required arguments
    end

    set DISK $argv[(math $num_opts + 1)]

    # Check whether the given disk is valid or not
    # Note: to quieten output stdout is redirected to /dev/null, and then stderr to wherever stdout is pointing.
    command lsblk $DISK > /dev/null ^&1
    if test $status -ne 0
        echo (string join "" "Invalid disk: " $DISK)
        return 1
    end

    set DISK_SIZE (lsblk --bytes --output SIZE --noheadings --nodeps $DISK)
    set DISK_SIZE_H (numfmt --to=iec-i --suffix=B $DISK_SIZE)

    set CONFIRM_MSG (string join "" "The following command will be run on "(set_color green)"$DISK ($DISK_SIZE_H):\n\n"(set_color red)"sudo "(set_color $fish_color_normal)"dd bs=4M if="(set_color green)"$DISK"(set_color $fish_color_normal)" | pv -petr -s $DISK_SIZE | gzip > "(set_color green)"$OUTPUT_FILE"(set_color $fish_color_normal)" \n\nAre you sure you want to continue?")

    while true
        read -p 'echo -ne "$CONFIRM_MSG [y/N]: "' -l confirm
        switch $confirm
            case Y y
                command sudo dd bs=4M if=$DISK | pv --wait --progress --eta --timer --rate --size $DISK_SIZE | gzip > $OUTPUT_FILE
            case '' N n
                return 1
        end
    end
end
