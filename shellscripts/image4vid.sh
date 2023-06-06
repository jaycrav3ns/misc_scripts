#!/usr/bin/bash

# Still image in place of a video stream

ffmpeg -loop 1 -i image.png -i joke-jp.mp3 \
	-vf "scale='min(1280,iw)':-2,format=yuv420p" \
	-c:v libx264 -preset medium -profile:v main \
	-c:a aac -shortest -movflags +faststart \
	output.mp4
