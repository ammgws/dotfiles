function git::is_stashed
  command git rev-parse --verify --quiet refs/stash >/dev/null
end

function git::get_ahead_count
  echo (command git log ^/dev/null | grep '^commit' | wc -l | tr -d " ")
end

function git::branch_name
  command git symbolic-ref --short HEAD
end

function git::is_touched
  test -n (echo (command git status --porcelain))
end

function fish_right_prompt
    set --local code $status
    test $code -ne 0
    and echo (dim)"("(trd)"$code"(dim)") "(off)

    if test -n "$SSH_CONNECTION"
        printf (trd)":"(dim)"$HOSTNAME "(off)
    end

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

  printf (dim)(date +%H(fst):(dim)%M(fst):(dim)%S)(off)" "
end
