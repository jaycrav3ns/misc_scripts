import youtube_dl

# Define the YouTube playlist URL
playlist_url = 'https://www.youtube.com/playlist?list=ABCDefghij1234567890'

# Create a YouTubeDL object
ydl = youtube_dl.YoutubeDL({'ignoreerrors': True})

# Extract all the video URLs in the playlist
video_urls = []
with ydl:
    playlist_dict = ydl.extract_info(playlist_url, download=False)
    for video in playlist_dict['entries']:
        video_url = video['webpage_url']
        video_urls.append(video_url)

# Print the video URLs
print(video_urls)
