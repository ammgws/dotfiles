function screenshot --description="Takes screenshot, uploads to Dropbox and copies link to clipboard."
    set -l SCREENSHOT_DIR /path/to/store_screenshots
    set -l SCROT_PATH /path/to/scrot
    set -l WAIT_TIME 5
    set -l TIMEOUT 3

    set -l FILENAME (string join "/" $SCREENSHOT_DIR "%Y%m%d_%Hh%Mm%Ss.png")
    
    set cRed (set_color red)
    set cGrn (set_color green)
    set cBlu (set_color blue)    
    set cRst (set_color $fish_color_normal)
    
    set -l DEPENDENCIES xclip scrot dropbox-cli
    for dependency in $DEPENDENCIES
        if not type -q $dependency
            echo $cRed"You must have $dependency installed."$cRst
        end
    end
    
    function print_help
        echo "Usage: screenshot [options] arguments..."
        echo "Arguments:"
        echo (set_color green)"-d"(set_color $fish_color_normal)": Enable debug output"
        echo (set_color green)"-l"(set_color $fish_color_normal)": Output URL to clipboard (default outputs image to clipboard)"
    end

    set DEBUG off
    set OUTPUT_MODE image
    set -l shortopt -o hdl
    set -l longopt -l help,debug,linkonly

    if getopt -T >/dev/null
		set longopt
    end

    if not getopt -n screenshot -Q $shortopt $longopt -- $argv >/dev/null
		return 1
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

			case --
				set -e opt[1]
				break
		end

		set -e opt[1]
	end

    set -l FINAL_FILENAME ($SCROT_PATH $FILENAME -q 100 -a -e 'echo $f')
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
    if test $DEBUG = "debug"; echo (string join "" (dropbox-cli sharelink $FINAL_FILENAME) "&raw=1"); end
    
    if test $OUTPUT_MODE = "linkonly"
        echo -n (string join "" (dropbox-cli sharelink $FINAL_FILENAME) "&raw=1") | xclip -sel clip
    else if test $OUTPUT_MODE = "image"
        xclip -sel clip -t image/png $FINAL_FILENAME
    end
    sleep $WAIT_TIME
end
