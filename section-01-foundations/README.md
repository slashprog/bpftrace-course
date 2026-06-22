# Section 1 — Foundations & Lab Setup

> 🎯 **Goal:** Understand where bpftrace fits in the observability landscape, get your lab running, and see your first "instant gratification" demo.

**Runtime:** ~1h 25m
**Lectures:** 12 (1.1 – 1.12)

---

## By the end of this section, you will:

- Understand why bpftrace exists and what makes it different from `strace` / `perf`
- Have a working lab environment (VirtualBox + Ubuntu 24.04 + bpftrace)
- Have traced a real "mystery latency" bug in under 5 minutes

---

## Lecture list

| # | Title | Runtime | Key files |
|---|-------|---------|-----------|
| 1.1 | Welcome & course overview | 5 min | — |
| 1.2 | Why observability matters | 8 min | — |
| 1.3 | The evolution of Linux tracing | 8 min | — |
| 1.4 | What is eBPF? A 2-minute primer | 6 min | — |
| 1.5 | The bpftrace architecture | 8 min | — |
| 1.6 | Choosing your lab environment | 6 min | [`docs/setup.md`](../docs/setup.md) |
| 1.7 | Setting up VirtualBox + Ubuntu 24.04 | 10 min | [`docs/setup.md`](../docs/setup.md) |
| 1.8 | Installing bpftrace | 5 min | [`scripts/install-bpftrace.sh`](../scripts/install-bpftrace.sh) |
| 1.9 | Hello, bpftrace: your first trace | 6 min | [`01-09-hello-world.bt`](01-09-hello-world.bt) |
| 1.10 | REPL vs scripts | 6 min | [`01-10-repl-vs-scripts.bt`](01-10-repl-vs-scripts.bt) |
| 1.11 | The 5-minute "instant gratification" demo | 10 min | [`01-11-instant-gratification.bt`](01-11-instant-gratification.bt) |
| 1.12 | Section 1 challenge + cheat sheet | 3 min | — |

---

## 🧪 Pre-flight check

Before starting this section, make sure your lab is ready:

```bash
# Should print a bpftrace version (≥ 0.20)
bpftrace --version

# Should be 5.15+ (Ubuntu 24.04 ships 6.x)
uname -r

# Should run without error for 3 seconds
sudo timeout 3 bpftrace -e 'kprobe:vfs_read { @[comm] = count(); }'
```

If any of these fail, run [`scripts/setup-lab.sh`](../scripts/setup-lab.sh) and try again.

---

## 📂 Files in this section

| File | What it does |
|------|--------------|
| `01-09-hello-world.bt` | The smallest possible bpftrace script — counts reads per process |
| `01-10-repl-vs-scripts.bt` | Same content, two forms (REPL one-liner and saved script) |
| `01-11-instant-gratification.bt` | The hero demo — traces a real "mystery latency" in 5 minutes |
| `assets/` | Sample output from each script |

---

## 🎬 The "instant gratification" demo (lecture 1.11)

This is the most important lecture in the course. The script ([`01-11-instant-gratification.bt`](01-11-instant-gratification.bt)) traces `vfs_read` latency — every read a process makes — and prints a histogram. The "demo" is a contrived scenario where a slow log file is the culprit, found in 30 seconds of running bpftrace.

**The point of the demo:** to give students an "I can do this!" moment before any of the theory lands.

---

## 🧠 Section cheat sheet

```
# Three things bpftrace does that nothing else does well:
1. Trace kernel functions without recompiling
2. Aggregate in-kernel (no per-event output overhead)
3. Stop with Ctrl-C and see answers, not raw data
```

---

## ➡️ Next section

[Section 2 — bpftrace Anatomy & First One-Liners →](../section-02-anatomy/)
