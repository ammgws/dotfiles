function export_ssh_pubkey
    set openssh_fmt (gpg --armor --export-ssh-key my-ssh-key-id!)

    # this is the format used in ssh logs, so is useful for debugging
    set sha256_fmt (echo $openssh_fmt | awk ' { print $2 }' | base64 --decode | sha256sum | awk '{ print $1 }' | xxd -r -p | base64)

    printf "In OpenSSH format:\n$openssh_fmt\n"
    printf "In SHA256 format (seen in SSH logs)):\n$sha256_fmt\n"
end
