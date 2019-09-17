function check_kernel --description='Output message if installed and running kernels are different.'
    function print_help
        echo "Usage: check_kernel [options]"
        echo "Options:"
        echo (set_color green)"--barmode"(set_color $fish_color_normal)": Output formatted text to be used in i3status block."
    end

    if not type -q pacman
        echo $cRed"You must have `pacman` installed."$cRst
        return 1
    end

    # default values (that can be changed via args)
    set OUTPUT_MODE boolean

    argparse --name screenshot 'h/help' 'b-barmode' -- $argv
    or return 1  #error

    if set -lq _flag_help
       print help
       return
    end

    if set -lq _flag_barmode
        set OUTPUT_MODE bar
    end

  # e.g. linux 4.18.5.arch1-1
  set installed (string match --regex '\d\d?.\d\d?.\d\d?' (pacman --query linux))
  # e.g. 4.18.4-arch1-1-ARCH
  set running (string match --regex '\d\d?.\d\d?.\d\d?' (uname --kernel-release))
  if test ! $running = $installed
    if test $OUTPUT_MODE = "boolean"
      return 1
    else
      printf "🐧😞"
    end
  else
    if test $OUTPUT_MODE = "boolean"
      return 0
    else
      printf "🐧☺️"
    end
  end
end
