#!/usr/bin/env bash
# 07-04-flamegraph.sh — Generate a CPU flame graph from bpftrace
#
# Requires:
#   - Brendan Gregg's FlameGraph repository:
#       git clone https://github.com/brendangregg/FlameGraph.git
#       export PATH=$PWD/FlameGraph:$PATH
#   - A bpftrace script that outputs folded stacks (see 06-13-cpu-oncpu-flamegraph.bt)

set -euo pipefail

# Configuration
DURATION=${DURATION:-30}      # seconds to sample
OUTPUT=${OUTPUT:-flamegraph.svg}
TARGET_PID=${TARGET_PID:-0}   # 0 = all processes
FOLDED=$(mktemp)

if ! command -v flamegraph.pl &>/dev/null; then
    echo "ERROR: flamegraph.pl not found in PATH"
    echo "Install: git clone https://github.com/brendangregg/FlameGraph.git"
    echo "         export PATH=\$PWD/FlameGraph:\$PATH"
    exit 1
fi

echo "Sampling on-CPU stacks for $DURATION seconds (PID=$TARGET_PID)..."
echo "Output: $OUTPUT"
echo

# Run bpftrace and capture folded stacks
TARGET_PID=$TARGET_PID timeout $DURATION bpftrace ../section-06-playbooks/06-13-cpu-oncpu-flamegraph.bt 2>/dev/null | \
    awk '
    /^@stacks:/ { in_block = 1; next }
    in_block && /^\s*$/ { in_block = 0 }
    in_block {
        # Parse "value stack" format
        match($0, /^[[:space:]]*\[?([0-9]+)\]?[[:space:]]+(.+)$/, arr)
        if (arr[1] != "" && arr[2] != "") {
            gsub(/[ \t]+$/, "", arr[2])
            print arr[1] " " arr[2]
        }
    }' > "$FOLDED"

if [[ ! -s "$FOLDED" ]]; then
    echo "No data collected. Was the target running?"
    exit 1
fi

echo "Generating flame graph..."
flamegraph.pl --title "bpftrace on-CPU flame graph" \
              --subtitle "PID=$TARGET_PID, ${DURATION}s" \
              --colors java \
              "$FOLDED" > "$OUTPUT"

echo "Done: $OUTPUT"
echo "Open it in a browser: file://$(realpath $OUTPUT)"
rm -f "$FOLDED"
