#!/bin/bash

usage() {
  echo -e "\nUsage: "$0" [FILE]"
  echo -e "Image to Base64 HTML <img> tag.\n"
}

# Print usage and exit if the file was not provided
[ $# -eq 0 ] && usage && exit 1

# Grab the image format
fmt=$(file "$1" | grep -iEo 'apng|bmp|gif|jpeg|png|webp' | head -n1 | tr '[:upper:]' '[:lower:]')

# Check if the image format is supported
[ -z "$fmt" ] && usage && exit 1

img="<img src='data:image/"$fmt";base64, $(base64 -w 0 "$1")' />"

# Create an IMG template
echo "$img"

exit 0
