function fish_prompt
    set --local last_exit_code $pipestatus
    set --local prompt_status (__fish_print_pipestatus "[" "]" "|" (set_color $fish_color_status) (set_color --bold $fish_color_status) $last_exit_code)
    echo -n -s "$prompt_status"

    if string length -q "$prompt_status"
        set prompt_char (set_color red)">"(set_color normal)
    else
        set prompt_char ">"
    end

    if set --query VIRTUAL_ENV
        echo -n -s (set_color --background blue white) "[" (basename "$VIRTUAL_ENV") "]" (set_color normal) " "
    end

    # could or may also need to check SSH_TTY or SSH_CONNECTION
    if set --query SSH_CLIENT
        echo -n -s (set_color --background green black) "SSH:" (hostname) (set_color normal) " "
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
