#!/bin/bash

# YouTube Download Script
# Purpose: This script facilitates downloading YouTube videos using yt-dlp, a powerful command-line program.
# Author: ComplexOrganizations
# Repository: https://github.com/complexorganizations/youtube-download-script

# Usage Instructions:
# 1. System Requirements: Ensure you have "curl" and "brew" installed on your system. This script is compatible with most Linux distributions, and MacOS.
# 2. Downloading the Script:
#    - Use the following command to download the script:
#      curl https://raw.githubusercontent.com/complexorganizations/youtube-download-script/main/yt-dlp-auto.sh -o yt-dlp-auto.sh
# 3. Making the Script Executable:
#    - Grant execution permissions to the script:
#      chmod +x yt-dlp-auto.sh
# 4. Running the Script:
#    - Prepare a file with YouTube video URLs, one URL per line.
#    - Execute the script and provide the file path as an argument:
#      bash yt-dlp-auto.sh
# 5. Follow the on-screen instructions to complete the download process for each video in the list.

# Troubleshooting:
# - If you encounter issues, ensure your system is up-to-date and retry the operation.
# - For specific errors, refer to the "Troubleshooting" section in the repository's documentation.

# Contributing:
# - Contributions to the script are welcome. Please follow the contributing guidelines in the repository.

# Contact Information:
# - For support, feature requests, or bug reports, please open an issue on the GitHub repository.

# License: MIT License

# Note: This script is provided "as is", without warranty of any kind. The user is responsible for understanding the operations and risks involved.

# Check if the script is running as root
function check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "Error: This script requires root privileges to execute. Please run it with administrative permissions in order to proceed."
        exit
    fi
}

# Call the function to check root privileges
check_root

# Check the current running OS.
function check-current-operatingsystem() {
    # Check if your running OS is Linux or macOS
    if [ -f /etc/os-release ]; then
        # If /etc/os-release file is present, source it to obtain system details
        # shellcheck source=/dev/null
        source /etc/os-release
        CURRENT_DISTRO=${ID} # CURRENT_DISTRO holds the system's ID
    fi
}

# Check the current running OS
check-current-operatingsystem

# Define a function to check system requirements
function installing-system-requirements() {
    # Check if the current Linux distribution is supported
    if { [ "${CURRENT_DISTRO}" == "ubuntu" ] || [ "${CURRENT_DISTRO}" == "debian" ] || [ "${CURRENT_DISTRO}" == "raspbian" ] || [ "${CURRENT_DISTRO}" == "pop" ] || [ "${CURRENT_DISTRO}" == "kali" ] || [ "${CURRENT_DISTRO}" == "linuxmint" ] || [ "${CURRENT_DISTRO}" == "neon" ] || [ "${CURRENT_DISTRO}" == "fedora" ] || [ "${CURRENT_DISTRO}" == "centos" ] || [ "${CURRENT_DISTRO}" == "rhel" ] || [ "${CURRENT_DISTRO}" == "almalinux" ] || [ "${CURRENT_DISTRO}" == "rocky" ] || [ "${CURRENT_DISTRO}" == "arch" ] || [ "${CURRENT_DISTRO}" == "archarm" ] || [ "${CURRENT_DISTRO}" == "manjaro" ] || [ "${CURRENT_DISTRO}" == "alpine" ] || [ "${CURRENT_DISTRO}" == "freebsd" ] || [ "${CURRENT_DISTRO}" == "ol" ] || [ "$(uname -s)" == "Darwin" ]; }; then
        # Check if required packages are already installed
        if { [ ! -x "$(command -v curl)" ] || [ ! -x "$(command -v brew)" ] || [ ! -x "$(command -v yt-dlp)" ] || [ ! -x "$(command -v ffmpeg)" ] || [ ! -x "$(command -v ffprobe)" ] || [ ! -x "$(command -v date)" ]; }; then
            # Install required packages depending on the Linux distribution
            if { [ "${CURRENT_DISTRO}" == "ubuntu" ] || [ "${CURRENT_DISTRO}" == "debian" ] || [ "${CURRENT_DISTRO}" == "raspbian" ] || [ "${CURRENT_DISTRO}" == "pop" ] || [ "${CURRENT_DISTRO}" == "kali" ] || [ "${CURRENT_DISTRO}" == "linuxmint" ] || [ "${CURRENT_DISTRO}" == "neon" ]; }; then
                apt-get update
                apt-get install build-essential procps curl file git -y
            elif { [ "${CURRENT_DISTRO}" == "fedora" ] || [ "${CURRENT_DISTRO}" == "centos" ] || [ "${CURRENT_DISTRO}" == "rhel" ] || [ "${CURRENT_DISTRO}" == "almalinux" ] || [ "${CURRENT_DISTRO}" == "rocky" ]; }; then
                yum check-update
                yum groupinstall "Development Tools" -y
                yum install procps-ng curl file git -y
            elif { [ "${CURRENT_DISTRO}" == "arch" ] || [ "${CURRENT_DISTRO}" == "archarm" ] || [ "${CURRENT_DISTRO}" == "manjaro" ]; }; then
                pacman -Sy --noconfirm base-devel procps-ng curl file git
            elif [ "${CURRENT_DISTRO}" == "alpine" ]; then
                apk update
                apk add curl coreutils
            elif [ "${CURRENT_DISTRO}" == "freebsd" ]; then
                pkg update
                pkg install curl coreutils
            elif [ "${CURRENT_DISTRO}" == "ol" ]; then
                yum check-update
                yum install curl coreutils -y
            fi
        fi
        if [ ! -x "$(command -v brew)" ]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        if [ ! -x "$(command -v yt-dlp)" ]; then
            brew install yt-dlp
        fi
        if [ ! -x "$(command -v ffmpeg)" ]; then
            brew install ffmpeg
        fi
        if [ ! -x "$(command -v fprobe)" ]; then
            brew install fprobe
        fi
        if [ ! -x "$(command -v date)" ]; then
            brew install coreutils
        fi
    else
        echo "Error: Your current distribution ${CURRENT_DISTRO} is not supported by this script. Please consider updating your distribution or using a supported one."
        exit
    fi
}

# Call the function to check for system requirements and install necessary packages if needed
installing-system-requirements

# Scrape and download
function scrape-download() {
    # Function to generate current timestamp
    function generate_timestamp() {
        date +"%Y-%m-%d_%H-%M-%S"
    }
    # Create a temporary directory to store downloaded content
    mkdir -p "video-$(generate_timestamp)"
    mkdir -p "audio-$(generate_timestamp)"
    # Create a variable to store the temporary directory path
    local video_dir="video-$(generate_timestamp)"
    local audio_dir="audio-$(generate_timestamp)"
    # List of YouTube video URLs
    local YouTubeURL=(
        "https://www.youtube.com/watch?v=FUKmyRLOlAA"
        "https://www.youtube.com/watch?v=yXkIHyBfns8"
        "https://www.youtube.com/watch?v=bj1JRuyYeco"
    )
    # Download videos concurrently
    for url in "${YouTubeURL[@]}"; do
        # Extract video and audio concurrently
        yt-dlp -f "bestvideo+bestaudio/best" --output "$video_dir/%(title)s.%(ext)s" "$url" &
        # Alternatively, download audio only (uncomment if needed)
        # yt-dlp -f "bestaudio/best" --extract-audio --audio-format mp3 --output "$audio_dir/%(title)s.%(ext)s" "$url" &
    done
    # Wait for all downloads to complete
    wait
    # Remove the empty temporary directory, if no files are present
    if [ -z "$(ls -A $video_dir)" ]; then
        rm -rf "$video_dir"
    elif [ -z "$(ls -A $audio_dir)" ]; then
        rm -rf "$audio_dir"
    fi
    # Print message when all videos are downloaded
    echo "Successful: All the content has been saved locally after downloading it from the internet."
}

# Scrape and download
scrape-download
