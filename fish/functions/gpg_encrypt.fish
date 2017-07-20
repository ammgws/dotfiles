function gpg_encrypt --description 'GPG encrypt a file or folder to the recipient and myself'
    # TODO: argument parsing, 
    #       option to upload to Dropbox/Gmail, 
    #       finish file/folder detection, 
    #       option to create file in same dir as input file instead of pwd
    #       option to disable random filename

    set -l INPUT_FILE $argv
    set -l RECIPIENT your_friend

    if not test -e $argv
        echo "File does not exist"
        #return 1
    end
    if not test -d $argv
        echo "Dir does not exist"
        #return 1
    end
    # echo (string sub --start 1 --length 1 $argv)

    set -l RANDOM_CHARS (cat /dev/random | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
    set -l OUTPUT_FILENAME (string join "/" (pwd) "%Y%m%d_%Hh%Mm%Ss" $RANDOM_CHARS)
    echo $OUTPUT_FILENAME

    set -l IS_DIR 1
    if test $IS_DIR = 1
        7z a (string join "" $RANDOM_CHARS.7z) $INPUT_FILE
    end

    gpg -esa -r your_key_name -r $RECIPIENT --output $OUTPUT_FILENAME $INPUT_FILE
end