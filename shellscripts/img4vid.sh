#!/usr/bin/bash

# Still image in place of a video stream
# Usage: ./img4vid.sh image.png audio.aac

ffmpeg -i "$1" -i "$2" \
	-loop 1 -vf "scale='min(1280,iw)':-2,format=yuv420p" \
	-c:v libx264 -preset medium -profile:v main \
	-c:a aac -shortest -movflags +faststart \
	output.mp4
