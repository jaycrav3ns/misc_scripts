#!/usr/bin/bash

# Show total size of current location recursively

size=$(du -sk . | awk '{size=$1; unit="KB"; if(size>1024){size=size/1024; unit="MB"} if(size>1024){size=size/1024; unit="GB"} printf "%.2f %s", size, unit}'); printf "Total: $size\n"
