function fish_prompt
  set --local code $status
  test $code -ne 0;
    and set --local colors 600 900 c00
    or set --local colors 333 666 aaa

  fish_prompt_helpers

  set --local pwd (prompt_pwd)
  set --local base (basename "$pwd")

  set --local expr "s|~|"(fst)"^^"(off)"|g; \
                   s|/|"(snd)"/"(off)"|g;  \
                   s|"$base"|"(fst)$base(off)" |g"

  echo -n (echo "$pwd" | sed --expression $expr)(off)

  for color in $colors
    echo -n (set_color $color)">"
  end
  if test $code -ne 0
    echo -n "("(trd)"$code"(dim)") "(off)
  else
    echo -n " "
  end

  if test "$USER" = "root"
    echo -n -s (set_color --background red black) "ROOT" (set_color normal) " "
  end

  if set --query VIRTUAL_ENV
    echo -n -s (set_color --background blue white) "[" (basename "$VIRTUAL_ENV") "]" (set_color normal) " "
  end

  # could or may also need to check SSH_TTY or SSH_CONNECTION
  if set --query SSH_CLIENT
    echo -n -s (set_color --background green white) "(SSH: " (hostname) ")" (set_color normal) " "
  end

  check_kernel
  if test $status -ne 0
    echo -n -s (set_color --background red white) "RESTART FOR NEW KERNEL!" (set_color normal) " "
  end
end
