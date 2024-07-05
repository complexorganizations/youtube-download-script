#!/usr/bin/env bash

# YouTube Download Script
# Purpose: This script facilitates downloading YouTube videos using yt-dlp, a powerful command-line program.
# Author: ComplexOrganizations
# Repository: https://github.com/complexorganizations/youtube-download-script

# Usage Instructions:
# 1. System Requirements: Ensure you have "curl" and "yt-dlp" installed on your system. This script is compatible with most Linux distributions.
# 2. Downloading the Script:
#    - Use the following command to download the script:
#      curl https://raw.githubusercontent.com/complexorganizations/youtube-download-script/main/yt-dlp-auto.sh -o /usr/local/bin/yt-dlp-auto.sh
# 3. Making the Script Executable:
#    - Grant execution permissions to the script:
#      chmod +x /usr/local/bin/yt-dlp-auto.sh
# 4. Running the Script:
#    - Prepare a file with YouTube video URLs, one URL per line.
#    - Execute the script and provide the file path as an argument:
#      bash /usr/local/bin/yt-dlp-auto.sh
# 5. Follow the on-screen instructions to complete the download process for each video in the list.

# Advanced Usage:
# - The script supports additional options and arguments. Check the script file or repository for details.

# Troubleshooting:
# - If you encounter issues, ensure your system is up-to-date and retry the operation.
# - For specific errors, refer to the "Troubleshooting" section in the repository's documentation.

# Contributing:
# - Contributions to the script are welcome. Please follow the contributing guidelines in the repository.

# Contact Information:
# - For support, feature requests, or bug reports, please open an issue on the GitHub repository.

# License: MIT License

# Note: This script is provided "as is", without warranty of any kind. The user is responsible for understanding the operations and risks involved.

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
    # Check if the current os has the required dependencies
    if [ "$CURRENT_DISTRO_LINUX" = true ]; then
        # Check if the required dependencies are installed on Linux
        if { [ ! -x "$(command -v brew)" ] || [ ! -x "$(command -v yt-dlp)" ] || [ ! -x "$(command -v ffmpeg)" ] || [ ! -x "$(command -v ffprobe)" ] || [ ! -x "$(command -v date)" ]; }; then
            # Set INSTALL_DEPENDENCIES_LINUX to true if the required dependencies are not installed
            INSTALL_DEPENDENCIES_LINUX=true
        fi
    # Check if the current os has the required dependencies
    elif [ "$CURRENT_DISTRO_MACOS" = true ]; then
        # Check if the required dependencies are installed on macOS
        if { [ ! -x "$(command -v brew)" ] || [ ! -x "$(command -v yt-dlp)" ] || [ ! -x "$(command -v ffmpeg)" ] || [ ! -x "$(command -v ffprobe)" ] || [ ! -x "$(command -v date)" ]; }; then
            # Set INSTALL_DEPENDENCIES_MACOS to true if the required dependencies are not installed
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
                # Install the required dependencies for Ubuntu and Debian
                sudo apt-get install build-essential procps curl file git -y
            # Check if the required dependencies are installed on Linux
            elif { [ "$CURRENT_DISTRO" = "fedora" ] || [ "$CURRENT_DISTRO" = "centos" ] || [ "$CURRENT_DISTRO" = "rhel" ]; }; then
                # Install the required dependencies for Fedora, CentOS, and RHEL
                sudo yum groupinstall "Development Tools" -y
                sudo yum install procps-ng curl file git -y
            # Check if the required dependencies are installed on Linux
            elif [ "$CURRENT_DISTRO" = "arch" ]; then
                # Install the required dependencies for Arch Linux
                sudo pacman -Sy --noconfirm base-devel procps-ng curl file git
            fi
            # Install the required dependencies for Linux
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            # Install the required dependencies for Linux
            brew install yt-dlp ffmpeg fprobe coreutils
        fi
    # Check if the current os has the required dependencies
    elif [ "$CURRENT_DISTRO_MACOS" = true ]; then
        # Install the required dependencies for macOS
        if [ "$INSTALL_DEPENDENCIES_MACOS" = true ]; then
            # Install the required dependencies for macOS
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            # Install the required dependencies for macOS
            brew install yt-dlp ffmpeg fprobe coreutils
        fi
    fi
}

# Install the required dependencies
install-dependencies

# Scrape and download
function scrape-download() {
    # Function to generate current timestamp
    function generate_timestamp() {
        date +"%Y-%m-%d_%H-%M-%S"
    }
    # This is the variable that will store the temporary directory
    temp_dir=$(generate_timestamp)
    # Create a temporary directory to store downloaded content
    mkdir -p "$temp_dir-video"
    mkdir -p "$temp_dir-audio"
    # List of YouTube video URLs
    YouTubeURL=(
        "https://www.youtube.com/watch?v=FUKmyRLOlAA"
        "https://www.youtube.com/watch?v=yXkIHyBfns8"
        "https://www.youtube.com/watch?v=bj1JRuyYeco"
    )
    # Download videos concurrently
    for url in "${YouTubeURL[@]}"; do
        # Get the current timestamp
        timestamp=$(generate_timestamp)
        # Extract video and audio concurrently
        yt-dlp -f "bestvideo+bestaudio/best" --output "$temp_dir-video/%(title)s.$timestamp.%(ext)s" "$url" &
        # Alternatively, download audio only (uncomment if needed)
        # yt-dlp -f "bestaudio/best" --extract-audio --audio-format mp3 --output "$temp_dir-audio/%(title)s.$timestamp.%(ext)s" "$url" &
    done
    # Wait for all downloads to complete
    wait
    # Print message when all videos are downloaded
    echo "All videos downloaded."
}

# Scrape and download
scrape-download
