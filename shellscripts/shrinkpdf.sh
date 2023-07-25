#!/bin/bash

# Useage: ./shrinkpdf.sh file.pdf

inpdf=$(basename ./"$1" .pdf)
info1=$(ls -sh1 "$inpdf.pdf")

ps2pdf -dPDFSETTINGS=/ebook "$inpdf.pdf" "new_$inpdf.pdf"

info2=$(ls -sh1 "out_$inpdf.pdf")
echo "Original:"
echo "$info1"
echo "After compression:"
echo -e "$info2\n"

exit 0
