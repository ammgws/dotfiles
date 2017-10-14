function ltail --description 'Tail the latest file in the directory. e.g. ltail -f or ltail -n 100'
    ls --all -t | head --lines 1 | xargs tail $argv
end
