# Capstone Setup — the "slow API" mystery

This directory contains the simulated environment for the capstone. The "API" is intentionally simple — bash + netcat — but it has a hidden performance bug that you'll discover using bpftrace.

## What's the bug?

The script reads `/var/log/syslog` on every request. This is fine when the file is in page cache, but creates a real bottleneck when the cache is cold. The bug is modeled after real-world issues like:

- A logger that's not properly buffered
- A misconfigured cache invalidation
- An N+1 query pattern that re-reads data unnecessarily
- A noisy neighbor in shared infrastructure

The actual cause doesn't matter for the teaching exercise — the **process** of finding it is what we're practicing.

## Setup

```bash
# Install netcat (if not already installed)
sudo apt-get install netcat-openbsd

# Start the "API"
./slow-api.sh

# In another terminal, generate some traffic
while true; do curl -s http://localhost:8080/ > /dev/null; sleep 1; done

# Now you can run the bpftrace scripts from the parent directory
cd ..
sudo bpftrace 09-02-triage.bt
```

## What you'll observe

With the bug active:
- Each request takes 50-200ms (the "slow" behavior)
- Without the bug, each request takes < 5ms
- The histogram in `09-02-triage.bt` will show the latency cluster

When you find the cause and remove it, re-run `09-05-verify-fix.bt` to confirm the latency distribution shifts back to the fast cluster.

## Stopping the server

`Ctrl-C` in the slow-api.sh terminal. Then kill the curl loop with `Ctrl-C` as well.

## Cleanup

```bash
# No persistent state to clean up — the server is stateless
# The log file is created via mktemp and will be cleaned up by your distro
```
