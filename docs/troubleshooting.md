# Troubleshooting Guide

The most common bpftrace errors and how to fix them.

---

## 🚫 Permission and security errors

### "Permission denied" when running bpftrace

**Cause:** bpftrace needs root (or CAP_BPF + CAP_PERFMON).

**Fix:**
```bash
sudo bpftrace -e 'kprobe:vfs_read { @[comm] = count(); }'
```

### "Failed to load BPF program: Operation not permitted"

**Cause:** Kernel lockdown is in "confidentiality" mode (blocks BPF for non-root).

**Fix:** Check current mode:
```bash
cat /sys/kernel/security/lockdown
# [none integrity confidentiality]
```

If "confidentiality", you need to either:
1. Boot the kernel with `lockdown=integrity` (or `=none`) on the kernel command line
2. Run in a development kernel (lockdown is enforced on signed Secure Boot systems)
3. Use a VM without Secure Boot lockdown

### "ERROR: failed to attach kprobe, Probe not found"

**Cause:** The kernel symbol doesn't exist (your kernel is too old, or you mistyped the name).

**Fix:** List available probes:
```bash
sudo bpftrace -l 'kprobe:vfs_read*'
```

Or use a wildcard and let bpftrace find it:
```bash
sudo bpftrace -e 'kprobe:vfs_read* { @[comm] = count(); }'
```

---

## 🔧 Build and version errors

### "bpftrace: error: implicit declaration of function 'XXX'"

**Cause:** Your bpftrace version doesn't support the feature you're using.

**Fix:** Check your version and the docs:
```bash
bpftrace --version
```

Most modern features (BTF, ringbuf, CO-RE helpers) need bpftrace ≥ 0.16. If you're on something older, upgrade:
```bash
# Ubuntu 24.04 has 0.20.x in the default repos
sudo apt-get update && sudo apt-get install --only-upgrade bpftrace
```

### "ERROR: failed to load program: Permission denied" (with proper root)

**Cause:** Kernel doesn't support the BPF program type, or the verifier rejected your script.

**Fix:** Re-run with `-d` for the dry-run output to see what bpftrace compiled:
```bash
sudo bpftrace -d -e 'kprobe:vfs_read { @[comm] = count(); }'
```

The verifier error is usually a loop, an out-of-bounds access, or an uninitialized variable. Look at the line number in the error.

### "ERROR: Can't get next line: Resource temporarily unavailable"

**Cause:** Output buffer is full (you generated more than the kernel can pipe out).

**Fix:** Aggregate in-kernel (use `@[]` maps) rather than `printf` per event:
```bash
# BAD: per-event printf
sudo bpftrace -e 'kprobe:vfs_read { printf("%s read\n", comm); }'

# GOOD: aggregated, output only on Ctrl-C
sudo bpftrace -e 'kprobe:vfs_read { @reads[comm] = count(); }'
```

---

## 🐛 Probe-specific issues

### "kretprobe:FUNC: failed to find kernel function"

**Cause:** Some kernel functions don't have a stable return point, or the symbol is inline.

**Fix:** Try a tracepoint instead, or use `kretprobe:FUNC+0`:
```bash
# Try:
sudo bpftrace -e 'kretprobe:tcp_connect { @[comm] = count(); }'

# If that fails, fall back to tracepoint:
sudo bpftrace -e 'tracepoint:tcp:tcp_set_state { @[comm] = count(); }'
```

### "kprobe: failed to attach: No such file or directory"

**Cause:** You specified a function that doesn't exist on your kernel.

**Fix:** Use `bpftrace -l` to discover what's available:
```bash
sudo bpftrace -l 'kprobe:tcp*' | head
```

### uprobes don't work on my binary

**Cause:** The binary is stripped of symbols, PIE (position-independent), or doesn't export the symbol you want.

**Fix:**
```bash
# Find the symbol
nm -D /path/to/binary | grep -i function_name

# Or list all uprobe targets in a binary
sudo bpftrace -l 'uprobe:/path/to/binary:*' | head
```

For PIE binaries, you may need the absolute path of the running binary:
```bash
readlink -f /proc/$(pidof myapp)/exe
```

---

## 📊 Output issues

### My histogram is empty

**Cause:** The probe never fires (no events match, or the predicate filtered everything out).

**Fix:** Add a debug print to confirm the probe is attaching:
```bash
sudo bpftrace -e 'kprobe:vfs_read { printf("hit\n"); @start[tid] = nsecs; }'
```

If you don't see "hit" output, the probe isn't matching anything.

### Output is overwhelming

**Cause:** You have a hot event and a per-event `printf`.

**Fix:** Aggregate, aggregate, aggregate. Use maps, time-based rollups, or write to a file:
```bash
# Roll up every 5 seconds
sudo bpftrace -e 'kprobe:vfs_read { @reads[comm] = count(); } interval:s:5 { time(); print(@reads); clear(@reads); }'
```

### Map data disappears when the script exits

**Cause:** bpftrace maps are in-kernel state — they're freed when the script exits.

**Fix:** Use `END` block to print results, or use `interval:s:N` for periodic output:
```bash
sudo bpftrace -e 'kprobe:vfs_read { @reads[comm] = count(); } END { print(@reads); }'
```

---

## 🐧 Distro-specific

### Ubuntu older than 22.04

bpftrace in older Ubuntu repos is outdated. Either:
- Upgrade to Ubuntu 22.04+ (recommended)
- Install bpftrace from source: https://github.com/iovisor/bpftrace/blob/master/INSTALL.md

### CentOS / RHEL 7

Kernel is too old (3.10). bpftrace won't work. Use CentOS Stream 9 or RHEL 8+.

### WSL2

See `docs/setup.md` for the WSL2-specific gotchas (systemd, kernel version).

### Raspberry Pi

Works on Pi 4+ with a 5.x kernel. Use Ubuntu Server 22.04+ for ARM64.

---

## 🆘 Still stuck?

1. Run `scripts/verify-install.sh` — it'll catch 80% of setup issues
2. Check `bpftrace --version` and `uname -r` — most issues are version mismatches
3. Read the bpftrace reference guide: https://github.com/iovisor/bpftrace/blob/master/docs/reference_guide.md
4. Open an issue on this repo with: your OS, kernel version, bpftrace version, full error output

Happy tracing! 🔍
