function vim --description 'Start vim with path to .vimrc'
    command --search --quiet vim
    and command vim -u "~/.config/vim/vimrc" $argv
    or return 1
end