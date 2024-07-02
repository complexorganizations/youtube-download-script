#!/bin/bash

# List of YouTube video URLs
urls=(
    "https://www.youtube.com/watch?v=5gnoVjpfWxU"
    "https://www.youtube.com/watch?v=WkJ0xB1dPwM"
)

# Function to download video and convert to MP4
download_video() {
    local url=$1
    echo "Downloading $url..."
    yt-dlp -f 'bestvideo+bestaudio/best' --recode-video mp4 "$url"
}

# Download videos concurrently
for url in "${urls[@]}"
do
    download_video "$url" &
done

# Wait for all downloads to complete
wait

echo "All videos downloaded."
