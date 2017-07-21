function gpg_encrypt --description 'GPG encrypt a file or folder to the recipient and myself'
    # TODO: argument parsing, 
    #       option to upload to Dropbox/Gmail, 
    #       option to create file in same dir as input file instead of pwd
    #       option to disable random filename
    #       check that 7z completed successfully
    #       delete 7z after encryption finished

    set -l INPUT_FILE $argv
    set -l RECIPIENT Wynand

    if test -f $argv
        echo "Input is a file"
        set IS_DIR 0
    end
    if test -d $argv
        echo "Input is a folder"
        set IS_DIR 1
        #return 1
    end
    # echo (string sub --start 1 --length 1 $argv)

    set -l USE_RELATIVE 1

    if test $USE_RELATIVE = 1
        set OUTPUT_DIR (dirname $INPUT_FILE)
    else
        set OUTPUT_DIR (pwd)
    end

    set -l RANDOM_CHARS (cat /dev/random | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
    set -l OUTPUT_FILENAME (string join "" (date +'%Y%m%d_%Hh%Mm%Ss_') $RANDOM_CHARS)
    set -l OUTPUT_FILEPATH (string join "/" $OUTPUT_DIR $OUTPUT_FILENAME)
    echo $OUTPUT_FILEPATH

    if test $IS_DIR = 1
        set -l ZIPPED_FOLDER (string join "" $RANDOM_CHARS.7z)
        7z a $ZIPPED_FOLDER $INPUT_FILE >/dev/null
        set INPUT_FILE $ZIPPED_FOLDER
    end

    gpg -esa -r Jason -r $RECIPIENT --output $OUTPUT_FILEPATH $INPUT_FILE
end
