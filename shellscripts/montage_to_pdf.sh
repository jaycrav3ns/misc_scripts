#!/bin/bash

output_dir="output_pdfs"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Iterate over sets of 8 images
for i in {0..100..8}; do
    input_images=$(seq -f "%d.png" $i $((i+7)))

    montage $input_images -tile 2x4 -geometry 332x238+5+5 "$output_dir/montage_output_$i.png"
    img2pdf --pagesize letter --imgsize 669 --output "$output_dir/cards_$i.pdf" --fit shrink "$output_dir/montage_output_$i.png"
done


#!/bin/bash

output_dir="output_pdfs"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Get a sorted list of image filenames (with quotes)
image_files=($(ls -1Q *.jpg | sort))

# Iterate over sets of 8 images
for ((i = 0; i < ${#image_files[@]}; i += 8)); do
    input_images=("${image_files[@]:i:8}")

    echo "Processing images: ${input_images[@]}"
    montage "${input_images[@]}" -tile 2x4 -geometry 332x238+5+5 "$output_dir/montage_output_$i.jpg"
    img2pdf --pagesize letter --imgsize 669 --output "$output_dir/cards_$i.pdf" --fit shrink "$output_dir/montage_output_$i.jpg"
done
