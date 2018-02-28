function fish_prompt
  # Start ohmyfish-batman theme default prompt
  test $status -ne 0;
    and set --local colors 600 900 c00
    or set --local colors 333 666 aaa

  set --local pwd (prompt_pwd)
  set --local base (basename "$pwd")


  set --local expr "s|~|"(fst)"^^"(off)"|g; \
                   s|/|"(snd)"/"(off)"|g;  \
                   s|"$base"|"(fst)$base(off)" |g"

  echo -n (echo "$pwd" | sed --expression $expr)(off)

  for color in $colors
    echo -n (set_color $color)">"
  end

  echo -n " "
  # End ohmyfish-batman theme default prompt

  if set --query VIRTUAL_ENV
    echo -n -s (set_color --background blue white) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
  end
  end
end
