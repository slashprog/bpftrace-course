# Section 7 — Ecosystem & Integration

> 🎯 **Goal:** Pipe bpftrace into other tools, generate flame graphs, and understand the bpftrace / bcc / perf / OpenTelemetry decision matrix.

**Runtime:** ~1h 20m
**Lectures:** 9 (7.1 – 7.9)

---

## By the end of this section, you will:

- Pipe bpftrace output to `jq`, `awk`, and other shell tools
- Generate flame graphs from bpftrace stack traces
- Know when to use bpftrace vs bcc vs perf vs OpenTelemetry
- Start building a personal one-liner library

---

## Lecture list

| # | Title | Runtime | Key files |
|---|-------|---------|-----------|
| 7.1 | Output formats: text vs JSON | 6 min | [`07-01-json.bt`](07-01-json.bt) |
| 7.2 | Piping to `jq` | 8 min | — |
| 7.3 | Introduction to FlameGraphs | 10 min | — |
| 7.4 | Generating flame graphs with bpftrace | 12 min | [`07-04-flamegraph.sh`](07-04-flamegraph.sh) |
| 7.5 | bpftrace vs bcc | 10 min | — |
| 7.6 | bpftrace vs perf | 8 min | — |
| 7.7 | bpftrace vs OpenTelemetry | 8 min | — |
| 7.8 | Custom visualizations: gnuplot | 10 min | — |
| 7.9 | Building your personal one-liner library | 8 min | — |

---

## ➡️ Next section

[Section 8 — Production Practice & the bpftrace Mental Model →](../section-08-production/)
