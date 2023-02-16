#!/bin/bash

set -euo pipefail

readonly os=$(uname)

kill_port() {
    local port=$1

    # Validate the port number
    if ! [[ "$port" =~ ^[0-9]{1,5}$ && "$port" -ge 0 && "$port" -le 65535 ]]; then
        echo "Invalid port number"
        exit 1
    fi

    # Check if port is in use
    if ! type lsof >/dev/null 2>&1 || ! lsof -Pi :"$port" -sTCP:LISTEN -t >/dev/null; then
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
}

# Check if port is provided
if [ $# -ne 1 ]; then
    echo "usage: killport <port>"
    exit 1
fi

kill_port "$1"

exit 0