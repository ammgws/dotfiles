function screenshot --description="Takes screenshot, uploads to Dropbox and copies link to clipboard."
    set -l SCREENSHOT_DIR /path/to/store_screenshots
    set -l WAIT_TIME 5
    set -l TIMEOUT 3

    # define colours to use when printing messages    
    set cRed (set_color red)
    set cGrn (set_color green)
    set cBlu (set_color blue)    
    set cRst (set_color $fish_color_normal)
    
    set -l DEPENDENCIES xclip scrot dropbox-cli
    for dependency in $DEPENDENCIES
        if not type -q $dependency
            echo $cRed"You must have $dependency installed."$cRst
            return 1  # error
        end
    end
    
    function print_help
        echo "Usage: screenshot [options]"
        echo "Options:"
        echo (set_color green)"-d"(set_color $fish_color_normal)": Enable debug output"
        echo (set_color green)"-l"(set_color $fish_color_normal)": Output URL to clipboard (default outputs image to clipboard)"
        echo (set_color green)"-o"(set_color $fish_color_normal)": Open URL in browser after upload"
    end

    # default values for optional arguments
    set DEBUG off
    set OUTPUT_MODE image
    set OPEN_URL 0

    set -l shortopt -o h,d,l,o
    # don't put a space after commas!
    set -l longopt -l help,debug,linkonly,openafter

    # Only enable longoptions if GNU enhanced getopt is available
    getopt -T >/dev/null
    if test $status -eq 4
        # don't put a space after commas!
        set longopt --longoptions help,debug,relative,self::,randomize
    else
        set longopt
    end

    if not getopt -n screenshot -Q $shortopt $longopt -- $argv >/dev/null
		return 1  # error
    end

	set -l tmp (getopt $shortopt $longopt -- $argv)
	eval set opt $tmp

	while count $opt >/dev/null
		switch $opt[1]
			case -h --help
				print_help
				return 0

			case -d --debug
				set DEBUG debug

			case -l --linkonly
				set OUTPUT_MODE linkonly

            case -o --openafter
                set OPEN_URL 1

			case --
				set -e opt[1]
				break
		end

		set -e opt[1]
	end

    set -l FILENAME (string join "/" $SCREENSHOT_DIR "%Y%m%d_%Hh%Mm%Ss.png")
    set -l FINAL_FILENAME (scrot $FILENAME -q 100 -a -e 'echo $f')
    if test $DEBUG = "debug"; echo $FINAL_FILENAME; end
   
    function getstatus
         set SYNC_STATUS (dropbox-cli filestatus $FINAL_FILENAME)

         if test (string match $SYNC_STATUS = 'up to date')
             return 0
         else
             return 1
         end
    end
    
    getstatus
    if test $DEBUG = "debug"; echo $status; end

    set TIME_ELAPSED 0
    while test $status -eq 1; and test $TIME_ELAPSED -lt $TIMEOUT;
        sleep 0.5
        set TIME_ELAPSED (math $TIME_ELAPSED + 1)
    end
    if test $DEBUG = "debug"; echo $TIME_ELAPSED; end
    
    set DROPBOX_LINK (string join "" (dropbox-cli sharelink $FINAL_FILENAME) "&raw=1") 
    if test $DEBUG = "debug"; echo $DROPBOX_LINK; end

    if test $OUTPUT_MODE = "linkonly"
        echo -n $DROPBOX_LINK | xclip -sel clip
    else if test $OUTPUT_MODE = "image"
        xclip -sel clip -t image/png $FINAL_FILENAME
    end

    if test $OPEN_URL = 1
        open $DROPBOX_LINK
    end

    sleep $WAIT_TIME
end
