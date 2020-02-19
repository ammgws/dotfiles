function fish_right_prompt
    set --local rp_sep "|"

    set --global __fish_git_prompt_show_informative_status 1
    set --global __fish_git_prompt_use_informative_chars 1
    set --global __fish_git_prompt_showcolorhints 1
    set --global __fish_git_prompt_char_stateseparator ""
    echo -n -s (set_color normal) (string trim --chars ' ()' (fish_vcs_prompt))"$rp_sep"

    # Show duration of last command
    if test $CMD_DURATION
        if functions --query humanize_duration
            echo -n -s (echo "$CMD_DURATION" | humanize_duration)
        else
            echo -n -s "$CMD_DURATION"
        end
    end

    echo -n -s "$rp_sep"(date +%H:%M:%S)
end
