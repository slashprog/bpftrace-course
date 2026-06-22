# Section 9 — Capstone & Wrap-up

> 🎯 **Goal:** Walk through a complete end-to-end debugging scenario. The "slow API" mystery, from first alert to verified fix.

**Runtime:** ~55m
**Lectures:** 6 (9.1 – 9.6)

---

## By the end of this section, you will:

- Have completed a full production-style investigation
- Have a personal mental model for triaging unfamiliar performance problems
- Know what to study next to keep growing

---

## The scenario

> A team has built a simple HTTP API. It's been running fine for weeks. Suddenly, requests start taking 5+ seconds. The team has tried everything they can think of: checked the database, restarted the app, scaled up. Nothing helps.
>
> **Your job:** figure out why. Using only bpftrace, in under 30 minutes.

The "API" is a script in [`setup/slow-api.sh`](setup/slow-api.sh) that intentionally has a hidden bug. The bug is designed to be discoverable through systematic bpftrace tracing.

---

## Lecture list

| # | Title | Runtime | Key files |
|---|-------|---------|-----------|
| 9.1 | The capstone setup: introducing the "slow API" | 8 min | [`setup/slow-api.sh`](setup/slow-api.sh) |
| 9.2 | Phase 1: where is the time going? | 12 min | [`09-02-triage.bt`](09-02-triage.bt) |
| 9.3 | Phase 2: drilling into the syscall | 12 min | [`09-03-drill-down.bt`](09-03-drill-down.bt) |
| 9.4 | Phase 3: the actual root cause | 10 min | [`09-04-root-cause.bt`](09-04-root-cause.bt) |
| 9.5 | Phase 4: verifying the fix | 8 min | [`09-05-verify-fix.bt`](09-05-verify-fix.bt) |
| 9.6 | Course wrap-up & what to learn next | 5 min | — |

---

## 🧪 To run the capstone

```bash
# 1. Start the "slow API" in one terminal
cd section-09-capstone/setup
./slow-api.sh

# 2. Generate some traffic in another terminal
while true; do curl -s http://localhost:8080/ > /dev/null; sleep 1; done

# 3. Now run the bpftrace scripts in order
#    Follow along with the lectures for the narrative
sudo bpftrace 09-02-triage.bt
sudo bpftrace 09-03-drill-down.bt
sudo bpftrace 09-04-root-cause.bt
```

---

## 📂 Files in this section

| File | What it does |
|------|--------------|
| `setup/slow-api.sh` | A simulated API server with a hidden performance bug |
| `setup/README.md` | How to set up and run the simulated environment |
| `09-02-triage.bt` | Phase 1: system-wide triage — where is the time going? |
| `09-03-drill-down.bt` | Phase 2: drill into the slow syscall |
| `09-04-root-cause.bt` | Phase 3: identify the actual cause |
| `09-05-verify-fix.bt` | Phase 4: confirm the fix worked |

---

## 🧠 What you'll learn

The capstone teaches a 4-phase troubleshooting methodology that you can use on any unfamiliar performance problem:

1. **Triage:** cast a wide net, see where time is being spent
2. **Drill-down:** focus on the slow subsystem
3. **Root cause:** find the specific bug
4. **Verify:** confirm the fix worked

This is the same workflow senior SREs use. After this course, you have the tools to do it yourself.

---

## 🎉 Course wrap-up

If you've reached the end:

- You have a runbook of 18 production-ready bpftrace scripts
- You know the entire Linux tracing landscape
- You can debug any Linux performance or security issue at the kernel layer
- You have a personal mental model for choosing the right tool

**The journey doesn't end here.** The next step is to apply bpftrace to your own systems. Pick one performance problem you've been meaning to investigate, and trace it. The first time you find a real bug, the course has paid for itself many times over.

---

## 🚀 What to learn next

| Path | What to study | Why |
|------|---------------|-----|
| **Lower level** | libbpf + BPF CO-RE in C | Production-grade, version-controlled BPF programs |
| **Higher level** | bcc tools, Cilium, Falco | The "real" observability stack in production |
| **Adjacent** | perf, OpenTelemetry, eBPF networking | Round out your tracing toolkit |
| **Same level** | Brendan Gregg's "Systems Performance" | The canonical book on Linux performance |

Recommended next book: **"Learning eBPF" by Liz Rice** (O'Reilly) — takes you from bpftrace to libbpf in C, in a single book.
