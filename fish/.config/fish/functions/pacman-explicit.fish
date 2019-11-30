function pacman-explicit
    pacman -Qe | grep -v "`pacman -Qqeg base-devel base`"
end
