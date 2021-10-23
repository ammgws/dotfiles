function fish_right_prompt
    set --local rp_sep "|"

    set --global __fish_git_prompt_use_informative_chars 1
    set --global __fish_git_prompt_showcolorhints 1
    set --global __fish_git_prompt_char_stateseparator ""
    echo -n -s (set_color normal) (fish_vcs_prompt %s)"$rp_sep"

    # Show duration of last command
    if test $CMD_DURATION
        if functions --query humantime
            echo -n -s (humantime "$CMD_DURATION")
        else
            echo -n -s "$CMD_DURATION"
        end
    end

    echo -n -s "$rp_sep"(date +%H:%M:%S)
end
