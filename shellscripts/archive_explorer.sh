#!/bin/bash

# check file argument is not empty 
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <archive_file>"
    exit 1
fi

# prepare file for mount
archive_file="$1"
unique_id=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 5 | head -n 1)
mount_point="/tmp/archive-$unique_id"
mkdir -p "$mount_point"

# mount archive
archivemount "$archive_file" "$mount_point" -o readonly -o auto_unmount -o auto_cache

# browse archive using nnn & cleanup on exit
if [ $? -eq 0 ]; then
    nnn "$mount_point"
    fusermount -u "$mount_point"
    rmdir "$mount_point"
else
    echo "Failed to mount the archive."
fi

exit 0
