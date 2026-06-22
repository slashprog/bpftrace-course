# One-Liner Library

A categorized collection of bpftrace one-liners and short scripts. This is the "cheat sheet" — scripts you can reach for when you need a quick answer to a specific question.

> 📖 For more, see [`docs/cheatsheet.md`](../docs/cheatsheet.md) — this directory has the **files**, the doc has the **inline one-liners** you can paste straight into a terminal.

## How this is organized

```
one-liners/
├── syscalls/      # Trace syscalls, count by process
├── filesystem/    # Reads, writes, page cache, file opens
├── network/       # TCP, DNS, packet drops
├── memory/        # Page faults, OOM, allocations
├── cpu/           # Scheduler, context switches, on/off-CPU
├── disk/          # Block I/O, latency, queue depth
└── security/      # Suspicious syscalls, privilege changes, exfiltration
```

## How to use

```bash
# Run a script
sudo bpftrace one-liners/syscalls/count-syscalls.bt

# Read a script first (good idea)
cat one-liners/filesystem/read-latency.bt

# Modify for your needs
cp one-liners/network/tcp-connect.bt my-tcp-trace.bt
sudo bpftrace my-tcp-trace.bt
```

## Conventions

Each script in this directory has a header comment block:

```bpftrace
#!/usr/bin/env bpftrace
/*
 * Title:    <one-line description>
 * Author:   Course author
 * Tested:   Ubuntu 24.04, kernel 6.x, bpftrace 0.20
 * Usage:    sudo bpftrace <filename>
 * Notes:    <anything important — e.g., requires CAP_BPF, kernel version>
 */
```

## Contributing

See [`CONTRIBUTING.md`](../CONTRIBUTING.md) for guidelines. The bar is: every script here should answer a real production-style question in under 30 seconds of running.
