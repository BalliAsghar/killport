#!/bin/sh

# Install KillPort
# Author: Balli Asghar

set -e  # Exit immediately if a command exits with a non-zero status

# Get the operating system
os=$(uname)

# Get the current directory
dir=$(pwd)

# Check if the script is already installed 
if command -v killport > /dev/null; then
    echo "KillPort is already installed"
    exit 0
fi

# clone the repo
git clone https://github.com/BalliAsghar/KillPort.git

# Change directory
cd KillPort

# Set the installation directory based on the operating system
if [ "$os" == "Darwin" ]; then
    # macOS
    install_dir="/usr/local/bin"
else
    # Linux
    install_dir="/usr/bin"
fi

# Install the script
sudo cp killport.sh "$install_dir"/killport

# Make the script executable
sudo chmod +x "$install_dir"/killport

# Change directory
cd "$dir"

# Remove the repo
rm -rf KillPort

echo "KillPort installed successfully"

exit 0
