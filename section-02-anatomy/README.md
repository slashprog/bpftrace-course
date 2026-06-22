# Section 2 — bpftrace Anatomy & First One-Liners

> 🎯 **Goal:** Learn the `probe / predicate / action` model and write your first ten one-liners.

**Runtime:** ~1h 30m
**Lectures:** 12 (2.1 – 2.12)

---

## By the end of this section, you will:

- Write bpftrace scripts using the three-part structure
- Use built-in context variables (`pid`, `tid`, `comm`, `cpu`, `nsecs`)
- Discover probes with `bpftrace -l` and wildcards

---

## Lecture list

| # | Title | Runtime | Key files |
|---|-------|---------|-----------|
| 2.1 | bpftrace syntax: probe / predicate / action | 8 min | — |
| 2.2 | Built-in context variables | 8 min | [`02-02-context-vars.bt`](02-02-context-vars.bt) |
| 2.3 | Function arguments: arg0..argN | 8 min | [`02-03-args.bt`](02-03-args.bt) |
| 2.4 | printf and string formatting | 6 min | — |
| 2.5 | Your first 10 one-liners | 10 min | [`02-05-first-ten.bt`](02-05-first-ten.bt) |
| 2.6 | Tracing syscalls: a deep dive | 10 min | [`02-06-syscall-trace.bt`](02-06-syscall-trace.bt) |
| 2.7 | BEGIN and END blocks | 5 min | — |
| 2.8 | Comments and script structure | 4 min | — |
| 2.9 | The bpftrace help system | 6 min | — |
| 2.10 | Discovering probes: wildcards, globs | 8 min | — |
| 2.11 | Common beginner pitfalls | 10 min | — |
| 2.12 | Section 2 challenge + cheat sheet | 4 min | — |

---

## 🧠 Mental model

Every bpftrace script (even one-liners) has this structure:

```
probe      → WHEN to fire
predicate  → IF this is true
action     → DO this
```

```bpftrace
kprobe:vfs_read                          // <-- probe
/pid == 1234/                            // <-- predicate (optional)
{                                        // <-- action
    @reads[comm] = count();
}
```

---

## 🧪 Pre-flight

You should be comfortable with:
- Running bpftrace with `sudo`
- Stopping with `Ctrl-C`
- Reading map output (`@name`, `@name[key]`)

If any of those are unclear, re-watch lecture 1.10.

---

## 📂 Files in this section

| File | What it does |
|------|--------------|
| `02-02-context-vars.bt` | Demonstrates `pid`, `tid`, `comm`, `cpu`, `nsecs` |
| `02-03-args.bt` | Shows how to read function arguments |
| `02-05-first-ten.bt` | A walkthrough of 10 essential one-liners |
| `02-06-syscall-trace.bt` | Tracing syscalls with `tracepoint:raw_syscalls:sys_enter` |

---

## ➡️ Next section

[Section 3 — Maps, Aggregations & Built-in Functions →](../section-03-maps/)
