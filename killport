#!/bin/bash

# killport - Kill a process using a specific port
# Usage: killport <port> [-f|--force] [-u|--udp]
# Example: killport 3000
# Author: https://github.com/BalliAsghar

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Parse command line arguments
force=0
udp=0
port=""

# write a cleanup function which basically aborts the script
cleanup() {
    echo -e "${RED}Aborting${NC}"
    exit 1
}

# Parse the port number from the command line arguments
if [[ $# -gt 0 ]]; then
    port=$1
else
    echo "Usage: killport <port> [-f|--force] [-u|--udp]" >&2
    exit 1
fi

# Validate the port number
if ! expr "$port" + 1 >/dev/null 2>&1 || ! ((port >= 1 && port <= 65535)); then
    echo -e "${RED}Invalid port number: $port${NC}" >&2
    exit 1
elif ((port <= 1023)); then
    echo -e "${RED}Port $port is a system port and cannot be killed${NC}" >&2
    exit 1
fi

# Parse any additional command line arguments
shift
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--force)
            force=1
            shift
            ;;
        -u|--udp)
            udp=1
            shift
            ;;
        *)
            echo -e "${RED}Invalid argument: $1${NC}" >&2
            exit 1
            ;;
    esac
done

# Find the process using the port
if [[ $udp -eq 1 ]]; then
    command="lsof -n -i udp:$port"
else
    command="lsof -n -i tcp:$port"
fi

if [[ $force -eq 1 ]]; then
    kill_command="kill -9"
else
    kill_command="kill"
fi

# set the trap to call the cleanup function
trap cleanup SIGINT SIGTERM

# Check if the lsof and kill commands are available
if ! command -v lsof >/dev/null 2>&1 || ! command -v kill >/dev/null 2>&1; then
    echo -e "${RED}Error: lsof and kill commands are required${NC}" >&2
    exit 1
fi

# Try running the command and capture any errors
if ! pids=$(eval "$command" 2>/dev/null | awk '{if(NR>1) print $2}'); then
    echo -e "${RED}Error: Failed to find process using port $port${NC}" >&2
    exit 1
fi

pids=$(eval "$command" | awk '{if(NR>1) print $2}')
if [[ -z $pids ]]; then

    echo -e "${YELLOW}No process is using port $port${NC}"
    exit 1
fi

# Prompt the user before killing the process(es), if force mode is not enabled
if [[ $force -eq 0 ]]; then
    echo -e "${YELLOW}The following process(es) are using port $port:${NC}"
    eval "$command"
    echo -e -n "Kill the process(es)? [y/N] "
    read answer
    if [[ $answer != "y" && $answer != "Y" ]]; then
        cleanup
    fi
fi

# 

# Kill the process(es)
for pid in $pids; do
    # Try running the kill command and capture any errors
    if ! eval "$kill_command $pid" 2>/dev/null; then
        echo -e "${RED}Error: Failed to kill process with PID $pid${NC}" >&2
    else
        echo -e "PID ${YELLOW}$pid${NC} killed"
    fi
done

echo -e "${GREEN}Done${NC}"
