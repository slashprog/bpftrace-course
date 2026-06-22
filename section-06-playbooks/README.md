# Section 6 — Real-world Playbooks

> 🎯 **Goal:** Build a personal runbook of 18 production-ready bpftrace scripts. Each is a self-contained case study you can reach for when production goes sideways.

**Runtime:** ~3h 00m
**Lectures:** 18 (6.1 – 6.18)

This is the **heart of the course**. After this section, you'll have a runbook you can deploy on any Linux system to triage the most common performance and security problems.

---

## By the end of this section, you will:

- Have a runbook of 18 production-ready bpftrace scripts
- Be able to triage latency, slowness, and anomalies in any Linux subsystem
- Know which probe and which aggregation fits which class of problem

---

## 📚 The 18 playbooks

### Filesystem (3)
- **6.1** Who is opening this file?
- **6.2** Read/write latency heatmaps
- **6.3** Page cache hit ratio

### Network (3)
- **6.4** TCP connect latency
- **6.5** Dropped packets
- **6.6** DNS resolution timing

### Process (2)
- **6.7** Forks/sec and execs
- **6.8** Short-lived processes

### Memory (3)
- **6.9** OOM events
- **6.10** Page fault breakdown
- **6.11** Swap usage by process

### CPU (3)
- **6.12** Scheduler latency
- **6.13** On-CPU flame graph with bpftrace
- **6.14** Off-CPU analysis

### Disk (2)
- **6.15** Per-I/O latency
- **6.16** Queue depth and merge stats

### Security (2)
- **6.17** Unexpected syscalls
- **6.18** Outbound network anomalies

---

## 📂 Files in this section

| File | What it does | When you'd use it |
|------|--------------|-------------------|
| `06-01-files-who-reads.bt` | Trace all file opens | "Who's touching this config file?" |
| `06-02-files-read-latency.bt` | Read/write latency histogram | "Is the disk slow or the FS?" |
| `06-03-files-cache-ratio.bt` | Page cache hit/miss ratio | "Should I add RAM or not?" |
| `06-04-net-tcp-connect.bt` | New TCP connections with target IP | "Who's connecting where?" |
| `06-05-net-dropped-packets.bt` | Packet drops per interface | "Why am I losing packets?" |
| `06-06-net-dns-timing.bt` | DNS resolution latency | "Is the resolver slow?" |
| `06-07-proc-forks.bt` | Fork rate and source | "Is something fork-bombing?" |
| `06-08-proc-short-lived.bt` | Short-lived process detection | "Is there a config issue causing restart loops?" |
| `06-09-mem-oom.bt` | OOM events with details | "What got OOM-killed and why?" |
| `06-10-mem-pagefaults.bt` | Page fault breakdown by process | "Who's thrashing?" |
| `06-11-mem-swap.bt` | Swap usage by process | "Is anything swapping?" |
| `06-12-cpu-sched-latency.bt` | Scheduler wakeup latency | "Why is my thread not getting CPU?" |
| `06-13-cpu-oncpu-flamegraph.bt` | On-CPU profile → flame graph | "Where is CPU being spent?" |
| `06-14-cpu-offcpu.bt` | Off-CPU analysis | "Why is my thread sleeping?" |
| `06-15-disk-latency.bt` | Per-I/O latency | "Is the disk slow?" |
| `06-16-disk-queue.bt` | Block queue depth and merges | "Are requests queuing up?" |
| `06-17-security-syscalls.bt` | Suspicious syscalls | "Is anything doing weird things?" |
| `06-18-security-outbound.bt` | Outbound network anomalies | "Is anything exfiltrating data?" |

---

## 🎯 How to use these

These aren't just "demo scripts." They're meant to be **reached for in real incidents**:

```bash
# "Production is slow, find me the slow thing"
sudo bpftrace section-06-playbooks/06-02-files-read-latency.bt

# "Are we OOMing?"
sudo bpftrace section-06-playbooks/06-09-mem-oom.bt

# "Where is CPU being spent? Build me a flame graph"
sudo bpftrace section-06-playbooks/06-13-cpu-oncpu-flamegraph.bt
```

Bookmark this directory. The first time you reach for it in an incident, the course has paid for itself.

---

## ➡️ Next section

[Section 7 — Ecosystem & Integration →](../section-07-ecosystem/)
