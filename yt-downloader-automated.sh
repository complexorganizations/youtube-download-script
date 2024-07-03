#!/usr/bin/env bash

# Check the current running OS.
function check-current-operatingsystem() {
    # Check if your running OS is Linux or macOS
    if [ -f /etc/os-release ]; then
        # If /etc/os-release file is present, source it to obtain system details
        # shellcheck source=/dev/null
        source /etc/os-release
        CURRENT_DISTRO=${ID}      # CURRENT_DISTRO holds the system's ID
        CURRENT_DISTRO_LINUX=true # CURRENT_DISTRO_LINUX is set to true as the system is Linux
    elif [ "$(uname -s)" == "Darwin" ]; then
        CURRENT_DISTRO="Darwin"   # If the output is Darwin, set CURRENT_DISTRO to macOS
        CURRENT_DISTRO_MACOS=true # CURRENT_DISTRO_MACOS is set to true as the system is macOS
    fi
}

# Check the current running OS
check-current-operatingsystem

# Check if the current os has the required dependencies
function check-dependencies() {
    if [ "$CURRENT_DISTRO_LINUX" = true ]; then
        # Check if the required dependencies are installed on Linux
        if { [ ! -x "$(command -v brew)" ] || [ ! -x "$(command -v yt-dlp)" ] || [ ! -x "$(command -v ffmpeg)" ] || [ ! -x "$(command -v ffprobe)" ]; }; then
            INSTALL_DEPENDENCIES_LINUX=true
        fi
    elif [ "$CURRENT_DISTRO_MACOS" = true ]; then
        # Check if the required dependencies are installed on macOS
        if { [ ! -x "$(command -v brew)" ] || [ ! -x "$(command -v yt-dlp)" ] || [ ! -x "$(command -v ffmpeg)" ] || [ ! -x "$(command -v ffprobe)" ]; }; then
            INSTALL_DEPENDENCIES_MACOS=true
        fi
    fi
}

# Check if the current os has the required dependencies
check-dependencies

# Download and install the required dependencies
function install-dependencies() {
    # Check if the current os has the required dependencies
    if [ "$CURRENT_DISTRO_LINUX" = true ]; then
        # Install the required dependencies for Linux
        if [ "$INSTALL_DEPENDENCIES_LINUX" = true ]; then
            # Check if the required dependencies are installed on Linux
            if { [ "$CURRENT_DISTRO" = "ubuntu" ] || [ "$CURRENT_DISTRO" = "debian" ]; }; then
                sudo apt-get install build-essential procps curl file git -y
            elif { [ "$CURRENT_DISTRO" = "fedora" ] || [ "$CURRENT_DISTRO" = "centos" ] || [ "$CURRENT_DISTRO" = "rhel" ]; }; then
                sudo yum groupinstall 'Development Tools' -y
                sudo yum install procps-ng curl file git -y
            elif [ "$CURRENT_DISTRO" = "arch" ]; then
                sudo pacman -Sy --noconfirm base-devel procps-ng curl file git
            fi
            # Install the required dependencies for Linux
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            brew install yt-dlp ffmpeg fprobe
        fi
    # Check if the current os has the required dependencies
    elif [ "$CURRENT_DISTRO_MACOS" = true ]; then
        # Install the required dependencies for macOS
        if [ "$INSTALL_DEPENDENCIES_MACOS" = true ]; then
            # Install the required dependencies for macOS
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            brew install yt-dlp ffmpeg fprobe
        fi
    fi
}

# Install the required dependencies
install-dependencies

function scrape-download-video() {
    # List of YouTube video URLs
    YouTubeURL=(
        "https://www.youtube.com/watch?v=FUKmyRLOlAA"
        "https://www.youtube.com/watch?v=yXkIHyBfns8"
        "https://www.youtube.com/watch?v=bj1JRuyYeco"
    )
    # Download videos concurrently
    for url in "${YouTubeURL[@]}"; do
        yt-dlp -f 'bestvideo+bestaudio/best' --output "%(title)s.%(ext)s" "$url" &
    done
    # Wait for all downloads to complete
    wait
    # Print message when all videos are downloaded
    echo "All videos downloaded."
}

# Scrape and download videos
scrape-download-video
