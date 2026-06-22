# kprobe vs tracepoint — the decision matrix

This is the question you'll ask yourself most often. Here's how to decide.

## TL;DR

**Default to tracepoints.** Fall back to kprobes only when tracepoints don't cover what you need.

---

## Comparison

| Aspect | kprobe | tracepoint |
|--------|--------|------------|
| Stability across kernels | ❌ Breaks with kernel upgrades | ✅ Stable ABI |
| Coverage | ✅ Any kernel function | ⚠️ Only functions with tracepoints |
| Performance | ⚠️ ~5–10% slower per event | ✅ Faster (no instrumentation overhead) |
| Argument access | ⚠️ Raw `arg0`–`argN`, need to know struct | ✅ Named `args->filename` etc. |
| Discovery | Easy (`bpftrace -l 'kprobe:vfs*'`) | Easy (`bpftrace -l 'tracepoint:syscalls:*'`) |
| Documentation | ⚠️ Read kernel source | ✅ Self-documenting (probe definitions) |
| Production safety | ⚠️ Risky — function may be inlined or removed | ✅ Safer — guaranteed interface |
| Custom kernel modules | ✅ Only option | ❌ Not available |
| Hot path tracing | ⚠️ Can be slow if function is hot | ✅ Lower overhead |

---

## When to use kprobes

1. **The function you want has no tracepoint.** This is the most common case. For example, `tcp_connect` has a tracepoint in newer kernels but not older ones, and many internal helpers (`inet_csk_accept`, `sk_filter_trim_cap`) have no tracepoints.
2. **You need access to a specific internal function.** Tracepoints only cover ~2000 stable entry points; kprobes give you ~30,000+ functions.
3. **You're debugging your own kernel module.** Modules don't have tracepoints.
4. **You're doing exploration.** When you don't know what's wrong, kprobes let you cast a wider net quickly.

## When to use tracepoints

1. **The function has a tracepoint.** Always check first. Run `bpftrace -l 'tracepoint:syscalls:*'` and `bpftrace -l 'tracepoint:tcp:*'` to see what's available.
2. **You want named argument access.** `args->filename` is much nicer than figuring out which arg is which.
3. **You want stability.** If your script will be deployed and run for months, tracepoints survive kernel upgrades.
4. **You're in production.** Tracepoints have lower overhead and are explicitly designed for production tracing.

---

## Practical workflow

1. **Step 1:** Look for a tracepoint. If one exists for what you want, use it.
   ```bash
   sudo bpftrace -l 'tracepoint:tcp:*'
   sudo bpftrace -l 'tracepoint:syscalls:*'
   sudo bpftrace -l 'tracepoint:sched:*'
   ```

2. **Step 2:** If no tracepoint, use a kprobe. Check it works:
   ```bash
   sudo bpftrace -e 'kprobe:tcp_connect { printf("hit\n"); }'
   ```

3. **Step 3:** If the kprobe fails to attach (symbol not found, function inlined), the function probably has no stable entry point. Try a different function higher in the call chain.

4. **Step 4:** Once you have something working, consider whether to convert to a tracepoint for stability.

---

## Hybrid approach

A common pattern: use tracepoints for the high-level events, and kprobes for the deep dives.

```bpftrace
// High-level: tracepoint for the syscall entry
tracepoint:syscalls:sys_enter_openat
{
    @opens[str(args->filename)] = count();
}

// Deep dive: kprobe on the actual file read
kprobe:vfs_read
{
    @reads[comm] = count();
}
```

---

## What about hardware and software events?

These are stable and very low-overhead — use them for performance counter work and scheduler tracing.

- `software:page-faults` — count page faults
- `software:cpu-migrations` — count thread migrations
- `hardware:cpu-cycles` — sample CPU cycles
- `hardware:cache-misses` — sample cache misses (good for hot path analysis)
