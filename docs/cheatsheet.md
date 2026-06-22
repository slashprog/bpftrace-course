# bpftrace One-Liner Cheat Sheet

A categorized library of useful bpftrace one-liners. Each is a self-contained script you can copy, modify, and run.

> **Conventions used in this cheat sheet:**
> - Run all scripts with `sudo bpftrace <script>.bt` or `sudo bpftrace -e '<script>'`
> - Hit **Ctrl-C** to stop and see results
> - Most scripts output aggregated counts/histograms; some stream live
> - `@comm` is shorthand for the current process's command name

---

## 🚀 Quick wins (run these first to see bpftrace's power)

```bash
# Syscalls per process (live counter)
sudo bpftrace -e 'kprobe:do_sys_open { @[comm] = count(); }'

# vfs_read latency histogram (μs)
sudo bpftrace -e 'kprobe:vfs_read { @start[tid] = nsecs; } kretprobe:vfs_read /@start[tid]/ { @usecs = hist((nsecs - @start[tid]) / 1000); delete(@start[tid]); }'

# Top processes by syscall rate (Ctrl-C after 5s)
sudo bpftrace -e 'tracepoint:raw_syscalls:sys_enter { @[comm] = count(); }'

# Trace new processes
sudo bpftrace -e 'tracepoint:sched:sched_process_exec { printf("%s → %s (pid %d)\n", comm, str(args->filename), args->pid); }'
```

---

## 📁 Filesystem

```bash
# Files being opened right now
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_openat { printf("%s opened %s\n", comm, str(args->filename)); }'

# Read latency (μs)
sudo bpftrace -e 'kprobe:vfs_read { @start[tid] = nsecs; } kretprobe:vfs_read /@start[tid]/ { @[comm] = hist((nsecs - @start[tid]) / 1000); delete(@start[tid]); }'

# Page cache hit ratio (look at "cache" vs "miss" output)
sudo bpftrace -e 'kprobe:filemap_get_pages { @hits = count(); } kprobe:filemap_add_to_page_cache { @misses = count(); }'

# Top files being read
sudo bpftrace -e 'kretprobe:vfs_read /retval > 0/ { @[comm] = sum(retval); }'

# Directory traversal count
sudo bpftrace -e 'kprobe:do_lookup { @[comm] = count(); }'
```

See `one-liners/filesystem/` for full scripts.

---

## 🌐 Network

```bash
# TCP connect events with target address
sudo bpftrace -e 'kprobe:tcp_connect { printf("%s → %pI4:%d\n", comm, args->sk__sk_common__skc_daddr, args->sk__sk_common__skc_dport); }'

# TCP accept events
sudo bpftrace -e 'kprobe:tcp_v4_rcv { printf("TCP packet to %s\n", comm); }'

# Packet drops (interface-level)
sudo bpftrace -e 'kprobe:dev_queue_xmit { @drops[comm] = count(); }'

# DNS queries (requires the right probe for your glibc version)
sudo bpftrace -e 'uprobe:/lib/x86_64-linux-gnu/libc.so.6:sendto { printf("%s sent %d bytes to %s\n", comm, arg2, ntop(2, arg4)); }'

# Top remote IPs (active connections)
sudo bpftrace -e 'kprobe:tcp_connect { @[ntop(2, args->sk__sk_common__skc_daddr)] = count(); }'
```

See `one-liners/network/` for full scripts.

---

## 🧠 Memory

```bash
# Page faults by process
sudo bpftrace -e 'kprobe:handle_page_fault { @[comm] = count(); }'

# Major vs minor page faults
sudo bpftrace -e 'kprobe:handle_mm_fault { @[comm, args->flags & 0x1 ? "MAJOR" : "MINOR"] = count(); }'

# OOM killer events
sudo bpftrace -e 'kprobe:oom_kill_process { printf("OOM killed: %s (pid %d) — %s\n", comm, pid, kstack); }'

# Memory allocations from slab
sudo bpftrace -e 'kprobe:kmem_cache_alloc { @bytes[comm] = sum(arg1); }'

# Swap-in events
sudo bpftrace -e 'kprobe:swap_readpage { @[comm] = count(); }'
```

See `one-liners/memory/` for full scripts.

---

## ⚡ CPU & Scheduler

```bash
# Top processes by CPU (sample-based)
sudo bpftrace -e 'kprobe:finish_task_switch { @[comm] = count(); }'

# Scheduler latency (time waiting to be scheduled)
sudo bpftrace -e 'kprobe:finish_task_switch { @start[pid] = nsecs; } kprobe:finish_task_switch /@start[args->prev_pid]/ { @lat[args->prev_comm] = hist((nsecs - @start[args->prev_pid]) / 1000); delete(@start[args->prev_pid]); }'

# Context switches
sudo bpftrace -e 'kprobe:finish_task_switch { @ctx_switches[cpu] = count(); }'

# Run queue length (sample every second)
sudo bpftrace -e 'kprobe:finish_task_switch { @start[pid] = nsecs; }'

# CPU time per process (sample for 5s, then Ctrl-C)
sudo bpftrace -e 'kprobe:finish_task_switch { @cpu[comm] = count(); }'
```

See `one-liners/cpu/` for full scripts and the flame-graph workflow in Section 7.

---

## 💾 Disk I/O

```bash
# Block I/O submission latency
sudo bpftrace -e 'kprobe:blk_mq_start_request { @start[arg0] = nsecs; } kretprobe:__blk_mq_issue_directly { @usecs = hist((nsecs - @start[arg0]) / 1000); delete(@start[arg0]); }'

# Read vs write distribution
sudo bpftrace -e 'kprobe:blk_mq_start_request { @type[arg1 & 1 ? "WRITE" : "READ"] = count(); }'

# I/O per device
sudo bpftrace -e 'kprobe:blk_mq_start_request { @[arg0 >> 32] = count(); }'

# Block I/O size histogram
sudo bpftrace -e 'kretprobe:blk_mq_start_request /retval == 0/ { @bytes = hist(retval); }'
```

See `one-liners/disk/` for full scripts.

---

## 🔒 Security

```bash
# New outbound TCP connections
sudo bpftrace -e 'kprobe:tcp_connect { printf("%s (%d) → %pI4:%d\n", comm, pid, args->sk__sk_common__skc_daddr, args->sk__sk_common__skc_dport); }'

# setuid calls (potential privilege escalation)
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_setuid { printf("%s (pid %d) called setuid(%d)\n", comm, pid, args->uid); }'

# File deletions
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_unlinkat { printf("%s deleted %s\n", comm, str(args->pathname)); }'

# Module loading
sudo bpftrace -e 'kprobe:load_module { printf("Module loaded: %s\n", kstack); }'

# ptrace (process debugging — potential exfiltration)
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_ptrace { printf("%s ptrace %d (%d)\n", comm, args->request, args->pid); }'
```

See `one-liners/security/` for full scripts.

---

## 🧰 Generic / utility

```bash
# Trace any function entry (replace FUNC with the symbol)
sudo bpftrace -e 'kprobe:FUNC { @[comm] = count(); }'

# Histogram of any function's duration (μs)
sudo bpftrace -e 'kprobe:FUNC { @start[tid] = nsecs; } kretprobe:FUNC /@start[tid]/ { @usecs = hist((nsecs - @start[tid]) / 1000); delete(@start[tid]); }'

# Watch a specific PID
sudo bpftrace -e 'kprobe:vfs_read /pid == 1234/ { @reads = count(); }'

# List all available kprobes matching a wildcard
sudo bpftrace -l 'kprobe:tcp_*'

# Watch stack traces on an event
sudo bpftrace -e 'kprobe:tcp_connect { @[kstack] = count(); }'
```

---

## 🛠️ Output tricks

```bash
# JSON output (pipe to jq)
sudo bpftrace -e 'kprobe:vfs_read { @[comm] = count(); }' -B none | head

# Quantile (p50, p95, p99)
sudo bpftrace -e 'kprobe:vfs_read { @ = quantize(retval); }'

# Time-series
sudo bpftrace -e 'kprobe:vfs_read { @reads = count(); }' --interval 1

# Periodic reports (every 5s)
sudo bpftrace -e 'kprobe:vfs_read { @reads[comm] = count(); } interval:s:5 { time(); print(@reads); clear(@reads); }'
```

---

## 📚 Where to next?

- **Section 6 (Real-world Playbooks)** has 18 fully-built scripts in `section-06-playbooks/`
- **Section 7 (Ecosystem)** covers flame graphs, JSON pipelines, and the bcc/bpftrace decision
- **Section 8 (Production Practice)** has the "when NOT to use bpftrace" decision matrix
- **Brendan Gregg's site** has the original 100+ one-liner collection: https://www.brendangregg.com/ebpf.html
