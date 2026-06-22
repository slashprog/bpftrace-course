# Section 3 — Maps, Aggregations & Built-in Functions

> 🎯 **Goal:** Use maps to aggregate in-kernel data, build histograms and stack traces, and apply built-in functions for quantization and symbol resolution.

**Runtime:** ~1h 35m
**Lectures:** 13 (3.1 – 3.13)

---

## By the end of this section, you will:

- Use scalar (`@name`) and associative (`@name[key]`) maps
- Build histograms with `hist()` and `lhist()`
- Capture kernel and user-space stack traces
- Apply built-in functions: `quantile`, `stats`, `join`, `ksym`, `usym`, `ntop`, `str`

---

## Lecture list

| # | Title | Runtime | Key files |
|---|-------|---------|-----------|
| 3.1 | Maps: @name and @name[key] basics | 8 min | — |
| 3.2 | count, sum, avg | 8 min | [`03-02-aggregations.bt`](03-02-aggregations.bt) |
| 3.3 | min, max | 6 min | — |
| 3.4 | Histograms: hist() deep dive | 10 min | [`03-04-histogram.bt`](03-04-histogram.bt) |
| 3.5 | Logarithmic histograms: lhist() | 8 min | [`03-05-lhist.bt`](03-05-lhist.bt) |
| 3.6 | Time-series: time() and delta | 8 min | — |
| 3.7 | Stack traces: kstack and ustack | 10 min | [`03-07-kstack.bt`](03-07-kstack.bt) |
| 3.8 | The stats() function | 5 min | — |
| 3.9 | quantile and percentiles | 8 min | [`03-09-quantile.bt`](03-09-quantile.bt) |
| 3.10 | join(): correlating events | 8 min | [`03-10-join.bt`](03-10-join.bt) |
| 3.11 | Clearing maps and @delete | 5 min | — |
| 3.12 | Symbol helpers: ksym, usym, ntop, str | 8 min | — |
| 3.13 | Section 3 challenge + cheat sheet | 4 min | — |

---

## 🧠 Mental model

Maps are **in-kernel state** that survives across events. Two flavors:

```bpftrace
@name           // scalar (one value)
@name[key]      // associative array (keyed map)
@name[key1, key2]   // multi-key map
```

Maps let you aggregate data **inside the kernel** — no per-event `printf` overhead, no copying data to userspace. The kernel just keeps a running count/histogram/etc.

---

## ➡️ Next section

[Section 4 — Probes Deep Dive →](../section-04-probes/)
