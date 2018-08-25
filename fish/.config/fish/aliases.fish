function ..; cd ..; end
function ...; cd ../..; end
function ....; cd ../../..; end

# Enable colour output for ls
function ls
    command ls --color=auto $argv
end
