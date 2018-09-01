function check_kernel --description='Output message if installed and running kernels are different.'
  set installed (string match --regex '\d\d?.\d\d?.\d\d?' (pacman --query linux))
  #                                                        linux 4.18.5.arch1-1
  set running (string match --regex '\d\d?.\d\d?.\d\d?' (uname --kernel-release))
  #                                                      4.18.4-arch1-1-ARCH
  if test ! $running = $installed
    printf 'Kernel out of date!'
  end
end
