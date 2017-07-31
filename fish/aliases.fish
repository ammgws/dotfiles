function ..; cd ..; end
function ...; cd ../..; end
function ....; cd ../../..; end

# Enable colour output for ls
function ls
    command ls --color=auto $argv
end

# Create parent folder(s) if not exist
function mkdir
    command mkdir -p
