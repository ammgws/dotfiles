function shrinkpdf --argument pdffile
    function print_help
        echo "Usage: shrinkpdf FILE"
        echo "Options:"
        echo (set_color green)"-h/--help"(set_color $fish_color_normal)": Print this help and exit"
    end

    argparse --name shrinkpdf h/help -- $pdffile
    or return 1

    if set -lq _flag_help
        print_help
        return
    end

    # https://unix.stackexchange.com/questions/274428/how-do-i-reduce-the-size-of-a-pdf-file-that-contains-images
    set $output string trim --right --chars=".pdf" $pdffile
    command gs -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -q -o $argv"_small.pdf" $pdffile
end