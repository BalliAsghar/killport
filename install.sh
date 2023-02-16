#!/bin/bash

# Install KillPort
# Author: Balli Asghar
# Get the operating system
os=$(uname)

# Get the current directory
dir=$(pwd)

# Check if the script is already installed 
if [ "$os" == "Darwin" ]; then
    # macOS
    if [ -f /usr/local/bin/killport ]; then
        echo "KillPort is already installed"
        exit 0
    fi
else
    # Linux
    if [ -f /usr/bin/killport ]; then
        echo "KillPort is already installed"
        exit 0
    fi
fi

# clone the repo
git clone https://github.com/BalliAsghar/KillPort.git

# Change directory
cd KillPort

# Install the script
if [ "$os" == "Darwin" ]; then
    # macOS
    sudo cp killport.sh /usr/local/bin/killport
    # Make the script executable
    sudo chmod +x /usr/local/bin/killport
else
    # Linux
    sudo cp killport.sh /usr/bin/killport
    # Make the script executable
    sudo chmod +x /usr/bin/killport
fi

# Change directory
cd "$dir"

# Remove the repo
rm -rf KillPort

echo "KillPort installed successfully"

exit 0