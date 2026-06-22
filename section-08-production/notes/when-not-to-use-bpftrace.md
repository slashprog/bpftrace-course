# When NOT to use bpftrace

A senior engineer knows what tool to reach for *and* what tool to put down. bpftrace is amazing, but it's not always the answer.

---

## The decision matrix

| If you need... | Use | Why |
|----------------|-----|-----|
| Quick ad-hoc tracing | **bpftrace** | Fast to write, instant results |
| Long-running production tracing | **bcc / libbpf** | Compiled, lower overhead, version-controlled |
| Application-level metrics | **OpenTelemetry / Prometheus** | Already integrated with your app |
| CPU profiling (production) | **perf** | More efficient, integrates with existing tools |
| Network packet processing | **XDP / TC / Cilium** | Purpose-built for that layer |
| Distributed tracing | **Jaeger / Zipkin / OTel** | Cross-host correlation |
| Audit logging | **auditd** | Designed for compliance/security logging |
| Network IDS/IPS | **Falco / Suricata** | Production-grade, optimized for security |

---

## When bpftrace is wrong for the job

### 1. Long-running, unattended tracing
- **Problem:** bpftrace has high per-event overhead and uses an interpreter-style execution model.
- **Better:** Compile your logic to BPF bytecode using bcc + libbpf + CO-RE.
- **Threshold:** If you'll run it for more than a few hours, consider bcc.

### 2. Per-event printf
- **Problem:** Each `printf` copies data from kernel to userspace and blocks.
- **Better:** Aggregate with maps, then print on `END` or `interval:s:N`.
- **Threshold:** If you find yourself reaching for printf, use maps instead.

### 3. Distributed / multi-host tracing
- **Problem:** bpftrace runs on a single host. It can't correlate events across machines.
- **Better:** OpenTelemetry with proper context propagation.
- **Threshold:** If "what happened across the cluster" is the question, bpftrace isn't it.

### 4. Application-level metrics
- **Problem:** bpftrace sees kernel events, not application business logic.
- **Better:** Instrument your app (Prometheus client, OTel SDK).
- **Threshold:** If "what's the conversion rate" is the question, bpftrace can't help.

### 5. Compliance / audit trails
- **Problem:** bpftrace has no tamper-evident logging.
- **Better:** auditd, syslog forwarding to a SIEM.
- **Threshold:** If regulators will audit the logs, bpftrace isn't appropriate.

### 6. Locked-down production kernels
- **Problem:** lockdown mode in "confidentiality" blocks BPF for non-root.
- **Better:** Talk to your platform team. Or use a sanctioned observability tool.
- **Threshold:** If the system has Secure Boot + lockdown, you may not be able to run bpftrace at all.

### 7. Network-layer processing
- **Problem:** bpftrace can observe network events but can't act on packets.
- **Better:** XDP, TC programs, Cilium.
- **Threshold:** If you want to drop, modify, or redirect packets, bpftrace is read-only.

---

## When bpftrace is RIGHT for the job

1. **Ad-hoc production debugging** — "I have 30 minutes, what's wrong?"
2. **One-off investigations** — "Did the new release change syscall patterns?"
3. **Building runbooks** — "What script do I run for the next OOM?"
4. **Learning** — "I want to understand how this kernel subsystem works"
5. **Rapid prototyping** — "Will tracing X give me what I need before I commit to a full bcc program?"
6. **Hot-path exploration** — "Is kprobe:Y actually safe to trace on the hot path?"

---

## The escalation path

A healthy tracing workflow goes:

```
1. bpftrace one-liner         (5 min — is the event there?)
2. bpftrace multi-line script (30 min — what does the distribution look like?)
3. bcc / libbpf program       (1 day — production-grade, version-controlled)
4. Custom BPF program in C    (1 week — specialized, optimized)
```

Most incidents stop at step 1 or 2. If you find yourself staying at step 2 for weeks, escalate to step 3.

---

## Tool comparison cheat sheet

```
bpftrace:     small, fast, read-only, high-level language
bcc:          medium, fast, C extensions, optimized
libbpf + C:   small, fastest, version-controlled, requires BTF
perf:         smallest, fastest, sampling only, deep kernel support
OpenTelemetry: distributed, language-agnostic, application-level
XDP / TC:     kernel-bypass, packet processing, requires dedicated programs
```

---

## TL;DR

bpftrace is the **on-ramp** to deep Linux observability. It's not the destination for every problem. Use it to learn, prototype, and triage. Escalate to bcc or libbpf when you need production-grade, long-running, or distributed tracing.
