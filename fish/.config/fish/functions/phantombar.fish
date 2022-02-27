complete -c phantombar --arguments '(__fish_complete_pids)' --no-files

function phantombar --argument-names pid --description "Show how far along a process is that working on a file. Useful for programs that do not show progress by default."
    # Based on idea from blogs.oracle.com/linux/solving-problems-with-proc-v2

    string length --quiet $pid
    or return 1

    command --search --quiet dialog
    or return 1

    for fd in /proc/$pid/fd/*
        echo -n $fd\t
        readlink $fd
    end | fzf | read --local --delimiter=\t fd filename

    string length --quiet $fd
    or return 1

    set --local fdinfo "/proc/$pid/fdinfo/"(basename $fd)
    set --local size (wc --bytes $fd  | string replace --regex --filter "^(\d+).*" '$1')
    while test -e $fd
        set progress (string replace --filter --regex "pos:\s(\d+)" '$1' < $fdinfo)
        math --scale=0 100 x $progress / $size
        sleep 1
    end | dialog --gauge "Progress reading $filename" 7 100
end
