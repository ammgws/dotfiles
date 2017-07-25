function perms --description 'return file/folder permissions in octal form'
    #stat -c '%A %a %h %U %G %s %Y %n' $argv | sed -r 's|.*\([0-9]\{10\}\).*|(date +"%b %e %H:%M" -d @\1)|eg'
    stat -c "%A/%a/%h/%U/%G/%s/%.19y/%n" $argv | column -t -s'/'
end
