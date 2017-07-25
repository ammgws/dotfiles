function perms --description 'return file/folder permissions in octal form'
    stat -c '%A %a %h %U %G %s %Y %n' $argv | sed 
"s/^.*\([0-9]\{13\}\).*/date -d @\1 +'%b %e %H:%M'/" 
end
