function ls --wraps ls --description "Enable colour output for ls"
    command ls --color=auto $argv
end
