# Section 5 — Control Flow & Multi-line Scripts

> 🎯 **Goal:** Move beyond one-liners. Build stateful multi-line scripts that respond to events, with conditional logic, loops, functions, and BTF struct access.

**Runtime:** ~1h 05m
**Lectures:** 9 (5.1 – 5.9)

---

## By the end of this section, you will:

- Use `if`/`else`, ternary operators, and loops (with the verifier's restrictions)
- Define and call functions within bpftrace
- Build state machines that follow a request through a pipeline
- Access struct fields via BTF in your scripts

---

## Lecture list

| # | Title | Runtime | Key files |
|---|-------|---------|-----------|
| 5.1 | Conditional logic: if / else | 8 min | [`05-01-conditional.bt`](05-01-conditional.bt) |
| 5.2 | Ternary operators | 5 min | — |
| 5.3 | Loops and unroll | 8 min | — |
| 5.4 | Defining functions | 8 min | — |
| 5.5 | Calling system() from bpftrace | 6 min | — |
| 5.6 | Variable scope and persistence | 6 min | — |
| 5.7 | Struct access with BTF | 10 min | — |
| 5.8 | Multi-line script patterns: state machines | 10 min | [`05-08-state-machine.bt`](05-08-state-machine.bt) |
| 5.9 | Section 5 challenge + cheat sheet | 4 min | — |

---

## 🧠 Mental model

bpftrace's control flow is **deliberately limited** by the verifier. It can't have arbitrary loops (infinite loops crash the kernel), unbounded recursion, or complex data structures. But what you *can* do is plenty for tracing work:

| You can do | You cannot do |
|------------|---------------|
| `if` / `else` / `ternary` | Arbitrary `for`/`while` loops |
| Bounded `for` with `unroll` | Functions that call themselves |
| Function calls (with limits) | Heap allocation in the kernel |
| Map-based state (persistent) | Global mutable state outside maps |

For anything the verifier rejects, the answer is usually: **build a state machine using maps** instead of trying to use normal control flow.

---

## ➡️ Next section

[Section 6 — Real-world Playbooks →](../section-06-playbooks/) (the heart of the course)
