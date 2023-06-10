import re
import pytube

# Define the YouTube playlist URL
playlist_url = 'https://www.youtube.com/playlist?list=ABCDefghij1234567890'

# Create a YouTube object
yt = pytube.Playlist(playlist_url)

# Extract all the video URLs in the playlist
video_urls = []
for video in yt.videos:
    video_url = video.watch_url
    match = re.search(r'v=([0-9A-Za-z-]{11})', video_url)
    if match:
        videoid = match.group(1)
        video_urls.append(video_url)

# Print the video URLs
print(video_urls)
