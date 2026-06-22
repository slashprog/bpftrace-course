# Section 8 — Production Practice & the bpftrace Mental Model

> 🎯 **Goal:** Use bpftrace on real systems confidently. Linux internals primer, the verifier, performance overhead, the "when NOT to use" framework, and CI testing.

**Runtime:** ~1h 30m
**Lectures:** 9 (8.1 – 8.9)

---

## By the end of this section, you will:

- Know the Linux internals bpftrace depends on
- Write scripts that work across kernel versions (BTF / CO-RE)
- Read verifier errors and fix your scripts
- Have a framework for choosing the right tool for the right job
- Set up CI testing for performance regressions

---

## Lecture list

| # | Title | Runtime | Key files |
|---|-------|---------|-----------|
| 8.1 | Linux internals primer: /proc and /sys | 10 min | — |
| 8.2 | Linux internals primer: cgroups, namespaces, sysctl | 10 min | — |
| 8.3 | BTF and CO-RE: cross-kernel portability | 10 min | [`08-03-btf-core.bt`](08-03-btf-core.bt) |
| 8.4 | The eBPF verifier | 10 min | — |
| 8.5 | Probe overhead: measuring with bpftrace | 10 min | [`08-05-overhead.bt`](08-05-overhead.bt) |
| 8.6 | ringbuf vs perf output | 8 min | — |
| 8.7 | bpftrace in incident response | 10 min | — |
| 8.8 | When NOT to use bpftrace | 10 min | [`notes/when-not-to-use-bpftrace.md`](notes/when-not-to-use-bpftrace.md) |
| 8.9 | CI testing for performance regressions | 10 min | — |

---

## ➡️ Next section

[Section 9 — Capstone & Wrap-up →](../section-09-capstone/)
