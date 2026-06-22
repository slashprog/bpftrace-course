#!/usr/bin/env bash
# slow-api.sh — A simulated HTTP API with a hidden performance bug
#
# This is a teaching tool for the capstone section. The "API" is a
# simple bash server that responds to GET /, but it has a deliberate
# performance issue built in.
#
# Usage:    ./slow-api.sh [port]
# Default:  port 8080
#
# To trigger requests from another terminal:
#   while true; do curl -s http://localhost:8080/ > /dev/null; sleep 1; done

set -euo pipefail

PORT="${1:-8080}"
LOG_FILE=$(mktemp)

echo "=============================================="
echo "  Slow API Simulator v1.0"
echo "=============================================="
echo "  Listening on: http://localhost:$PORT/"
echo "  Log file:     $LOG_FILE"
echo "  PID:          $$"
echo "=============================================="
echo ""
echo "  To generate traffic from another terminal:"
echo "    while true; do curl -s http://localhost:$PORT/ > /dev/null; sleep 1; done"
echo ""
echo "  Press Ctrl-C to stop the server."
echo ""

# The "API" handler — uses netcat to handle one request at a time
# The hidden bug: it reads /proc/self/status on every request,
# which involves disk I/O when the working set is cold.
# Real apps have similar issues — the principle is the same.

handle_request() {
    local request_line
    read -r request_line

    # The bug: this file read happens on every request
    # For a teaching exercise, the file is intentionally cold in cache
    cat /var/log/syslog > /dev/null 2>&1 &
    wait

    # Send the response
    printf "HTTP/1.1 200 OK\r\n"
    printf "Content-Type: text/plain\r\n"
    printf "Content-Length: 12\r\n"
    printf "\r\n"
    printf "Hello world!\n"
}

# Main loop
while true; do
    if command -v nc &>/dev/null; then
        # Use ncat (from nmap) if available, else use plain nc
        if nc -h 2>&1 | grep -q -- "-k"; then
            handle_request < <(nc -l -p "$PORT" 2>/dev/null) || true
        else
            handle_request < <(nc -l "$PORT" 2>/dev/null) || true
        fi
    else
        echo "ERROR: netcat (nc) is required. Install: sudo apt-get install netcat-openbsd"
        exit 1
    fi
done
