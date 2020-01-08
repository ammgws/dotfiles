function git::is_stashed
    command git rev-parse --verify --quiet refs/stash >/dev/null
end

function git::get_ahead_count
    echo (command git log ^/dev/null | grep '^commit' | wc --lines | tr --delete " ")
end

function git::branch_name
    if git symbolic-ref --short HEAD 2>/dev/null
        echo (command git symbolic-ref --short HEAD 2> /dev/null)
    else
        echo (command git rev-parse --short HEAD)
    end
end

function git::is_touched
    test -n (echo (command git status --porcelain))
end

function fish_right_prompt
    fish_prompt_helpers

    if git rev-parse 2>/dev/null
        git::is_stashed; and echo (trd)"^"(off)
        printf (snd)"("(begin
            if git::is_touched
                echo (trd)"*"(off)
            else
                echo ""
            end
        end)(fst)(git::branch_name)(snd)(begin
            set --local count (git::get_ahead_count)
            if test $count -eq 0
                echo ""
            else
                echo (trd)"+"(fst)$count
            end
        end)(snd)") "(off)
    end

    # Show duration of last command in secs
    if test $CMD_DURATION
        set duration (echo "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}')
        echo $duration
    end
    printf (dim)"|"(off)
    printf (date +%H(fst):(off)%M(fst):(off)%S)" "
end
