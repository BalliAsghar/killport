#!/bin/bash

# Kill a process listening on a given port

# Usage: killport <port>
# Example: killport 3000
# Author: https://github.com/BalliAsghar

# Get the operating system
os=$(uname)

# Get the port number
port=$1

# Check if port is provided
if [ -z "$port" ]; then
    echo "usage: killport <port>"
    exit 1
fi

# Validate the port number
if ! [[ "$port" =~ ^[0-9]{1,5}$ && "$port" -ge 0 && "$port" -le 65535 ]]; then
    echo "Invalid port number"
    exit 1
fi

# Check if port is in use
if ! lsof -Pi :"$port" -sTCP:LISTEN -t >/dev/null; then
    echo "Port $port is not in use"
    exit 1
fi

# Kill the process
if [ "$os" == "Darwin" ]; then
    # macOS
    lsof -ti tcp:"$port" | xargs kill
else
    # Linux
    fuser -k "$port"/tcp
fi

echo "Process on port $port killed"
exit 0
