# Section 4 — Probes Deep Dive

> 🎯 **Goal:** Master every probe type bpftrace supports — kprobes, tracepoints, uprobes, USDT — and know when to use which.

**Runtime:** ~2h 10m
**Lectures:** 16 (4.1 – 4.16)

This is the **biggest** section of the course. Probes are the core differentiator of bpftrace — they let you attach to *any* function in the kernel or in user-space, with no recompilation.

---

## By the end of this section, you will:

- Attach to any kernel function with `kprobe` / `kretprobe`
- Use `tracepoint` for stable, supported kernel events
- Trace user-space functions with `uprobe` / `uretprobe`
- Use USDT for instrumented binaries (MySQL, Postgres, Node.js)
- Pick the right probe type for any debugging problem

---

## Lecture list

| # | Title | Runtime | Key files |
|---|-------|---------|-----------|
| 4.1 | Probe taxonomy | 8 min | — |
| 4.2 | kprobe: kernel function entry | 10 min | [`04-02-kprobe.bt`](04-02-kprobe.bt) |
| 4.3 | kretprobe: kernel return values | 8 min | [`04-03-kretprobe.bt`](04-03-kretprobe.bt) |
| 4.4 | Kprobe wildcards | 8 min | — |
| 4.5 | Kprobe offsets and module probes | 8 min | — |
| 4.6 | tracepoint: stable kernel events | 10 min | [`04-06-tracepoint.bt`](04-06-tracepoint.bt) |
| 4.7 | Kprobe vs tracepoint | 8 min | [`notes/kprobe-vs-tracepoint.md`](notes/kprobe-vs-tracepoint.md) |
| 4.8 | uprobe: user-space functions | 10 min | [`04-08-uprobe.bt`](04-08-uprobe.bt) |
| 4.9 | uretprobe: user return values | 8 min | — |
| 4.10 | Uprobe wildcards and offsets | 6 min | — |
| 4.11 | USDT: user statically defined tracing | 10 min | [`04-11-usdt.bt`](04-11-usdt.bt) |
| 4.12 | Software events | 8 min | — |
| 4.13 | Hardware events | 8 min | — |
| 4.14 | interval and timer probes | 5 min | — |
| 4.15 | BTF-powered probes | 10 min | [`04-15-btf.bt`](04-15-btf.bt) |
| 4.16 | Section 4 challenge + cheat sheet | 4 min | — |

---

## 🧠 Mental model

Every probe answers the question: **"When X happens, do Y."**

| Probe type | Attaches to | Stability | Best for |
|------------|-------------|-----------|----------|
| `kprobe` | Any kernel function entry | Unstable (changes per kernel version) | Quick wins, exploration |
| `kretprobe` | Kernel function return | Unstable | Latency measurement, return values |
| `tracepoint` | Stable, named kernel events | **Stable** | Production-safe tracing |
| `uprobe` | Any user-space function | Per-binary | Application debugging, no source needed |
| `uretprobe` | User-space return | Per-binary | User-space latency |
| `usdt` | Pre-instrumented user-space probes | Per-binary | Tracing MySQL, Postgres, Node.js, etc. |
| `software` | Kernel software events | Stable | Page faults, scheduler events |
| `hardware` | CPU performance counters | Stable | CPU profiling, cache misses |

---

## 📂 Files in this section

| File | What it does |
|------|--------------|
| `04-02-kprobe.bt` | Basic kprobe on vfs_read |
| `04-03-kretprobe.bt` | kretprobe with latency histogram |
| `04-06-tracepoint.bt` | Stable tracepoints for openat and friends |
| `04-08-uprobe.bt` | uprobes on a user-space binary (e.g., `sleep`) |
| `04-11-usdt.bt` | USDT probes for MySQL/Postgres (when available) |
| `04-15-btf.bt` | BTF-powered struct access |
| `notes/kprobe-vs-tracepoint.md` | Decision matrix |

---

## 🎯 The big decision: kprobe vs tracepoint

Most of the time, **use tracepoints first** — they're stable across kernel versions and have named, well-typed arguments. Fall back to kprobes when you need something tracepoints don't cover (very common: tracing a custom kernel module, or a function that has no tracepoint).

Full decision matrix: [`notes/kprobe-vs-tracepoint.md`](notes/kprobe-vs-tracepoint.md)

---

## ➡️ Next section

[Section 5 — Control Flow & Multi-line Scripts →](../section-05-control-flow/)
