function shrinkpdf $argv
  # https://unix.stackexchange.com/questions/274428/how-do-i-reduce-the-size-of-a-pdf-file-that-contains-images
  set $output string trim --right --chars=".pdf" $argv
  command gs -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -q -o $argv"_small.pdf" $argv
end
