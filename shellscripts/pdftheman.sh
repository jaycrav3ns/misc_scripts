#!/bin/bash
# Usage: ./pdftheman.sh COMMAND

in="$1"

man -t "$in" | ps2pdfwr -DefaultRenderingIntent=/prepress - > ~/"manpage_$in".pdf

echo -e "Finished.\n"
exit 0
