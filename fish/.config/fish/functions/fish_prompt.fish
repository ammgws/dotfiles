function fish_prompt
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
    set -l normal (set_color normal)
    set -q fish_color_status
    or set -g fish_color_status --background=red white

    # Write pipestatus
    # If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
    set -l bold_flag --bold
    set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
    if test $__fish_prompt_status_generation = $status_generation
        set bold_flag
    end
    set __fish_prompt_status_generation $status_generation
    set -l status_color (set_color $fish_color_status)
    set -l statusb_color (set_color $bold_flag $fish_color_status)
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

    echo -n -s "$prompt_status"

    if string length -q "$prompt_status"
        set prompt_char (set_color red)">"(set_color normal)
    else
        set prompt_char ">"
    end

    if status is-login
        switch $hostname
            case '*lap*'
                echo -n (cat /sys/class/power_supply/CMB1/capacity)"% "
                echo -n (set_color green)'['(iwctl station wlan0 show | string replace --regex --filter '^\s+Connected network\s+(\S*)\s*' 'WIFI: $1')']'(set_color normal)
            case '*'
        end
    end

    if set --query VIRTUAL_ENV
        echo -n -s (set_color --background blue white) "[" (basename "$VIRTUAL_ENV") "]" (set_color normal) " "
    end

    # could or may also need to check SSH_TTY or SSH_CONNECTION
    if set --query SSH_CLIENT
        echo -n -s (set_color --background green black) "SSH:" (prompt_hostname) (set_color normal) " "
    end

    if functions --query check_kernel
        check_kernel
        if test "$status" -ne 0
            echo -n -s (set_color --background red white) "RESTART FOR NEW KERNEL!" (set_color normal) " "
        end
    end

    if set --query SWAYSOCK
        and not set --query SSH_CLIENT
        # just rely on the window title since it shows pwd by default
    else
        echo -n (prompt_pwd)
    end

    echo -n -s $prompt_char
end
