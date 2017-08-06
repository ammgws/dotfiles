function check_gfx_drivers
    command lspci -nnk | grep -i vga -A3 | grep 'in use'
end

