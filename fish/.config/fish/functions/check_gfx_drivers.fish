function check_gfx_drivers
    command lspci -nnk | grep --ignore-case vga -A3 | grep 'in use'
end
