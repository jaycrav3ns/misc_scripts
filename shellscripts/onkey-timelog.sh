#!/bin/bash


# I've used this to make .SRT subtitles & to mark keyframe insertion points
# You can start the video by un-commenting one of these lines.
#
# Open video directly (mpv, ffplay, mplayer, cvlc) or whatever you have.
# mpv video.mp4 &
#
# Use yad (or zenity) "Open file..." GUI:
# yad --file --command=mpv &


# File path for the log file
log_file="$HOME/onkeytime.log"

# Initialize variables
start_time=$(date +%s.%N)
last_logged_time=$start_time

# Function to calculate and log elapsed time
log_elapsed_time() {
    local current_time=$(date +%s.%N)
    local elapsed_time=$(bc <<< "scale=1; $current_time - $start_time")
    echo "Elapsed time: $elapsed_time seconds" >> "$log_file"
    last_logged_time=$current_time
}

# Function to display the elapsed time
display_elapsed_time() {
    local current_time=$(date +%s.%N)
    local elapsed_time=$(bc <<< "scale=1; $current_time - $start_time")
    echo -ne "Elapsed time: $elapsed_time seconds\r"
}

# Trap spacebar key press
trap log_elapsed_time SIGINT

# Clear the log file
> "$log_file"

echo "Timer started. Press spacebar to log the elapsed time. Press Ctrl+C to exit."

# Loop to read input and display elapsed time
while true; do
    display_elapsed_time
    read -rsn1 input
    if [[ $input == " " ]]; then
        log_elapsed_time
    fi
done
