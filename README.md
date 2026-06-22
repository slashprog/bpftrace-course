# Linux Observability with bpftrace: Debug, Trace & Fix

Source code, scripts, and lab materials for the training course **Linux Observability with bpftrace: Debug, Trace & Fix** — hands-on eBPF tracing for SREs, DevOps, and performance engineers.

[![Course](https://img.shields.io/badge/Udemy-Course-blue)](https://www.udemy.com/) [![bpftrace](https://img.shields.io/badge/bpftrace-%E2%89%A5%200.20-orange)](https://github.com/iovisor/bpftrace) [![Kernel](https://img.shields.io/badge/Kernel-7.x-lightgrey)](https://www.kernel.org/) [![Ubuntu](https://img.shields.io/badge/Ubuntu-26.04%20LTS-E95420)](https://releases.ubuntu.com/24.04/)

---

## 🚀 Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/<your-org>/bpftrace-course.git
cd bpftrace-course

# 2. Run the lab setup (idempotent — safe to re-run)
sudo ./scripts/setup-lab.sh

# 3. Verify everything works
sudo ./scripts/verify-install.sh

# 4. Run your first bpftrace script
sudo bpftrace one-liners/syscalls/count-syscalls.bt
```

That's it. You should see syscalls counted by process. **Ctrl-C to exit.**

---

## 📚 What's in this repo

This repo is organized to mirror the course lecture-by-lecture. Every script from every lecture lives here, tagged by section and lecture number.

```
bpftrace-course/
├── docs/                          # Setup walkthrough, cheat sheets, troubleshooting
├── scripts/                       # Lab setup & verification scripts
├── one-liners/                    # The bpftrace "cheat sheet" library
│   ├── syscalls/
│   ├── latency/
│   ├── network/
│   ├── memory/
│   ├── cpu/
│   ├── disk/
│   └── security/
├── section-01-foundations/        # Why bpftrace, lab setup, hello world
├── section-02-anatomy/            # probe / predicate / action, one-liners
├── section-03-maps/               # Maps, aggregations, built-in functions
├── section-04-probes/             # kprobes, tracepoints, uprobes, USDT
├── section-05-control-flow/       # if/else, functions, state machines
├── section-06-playbooks/          # 18 production-ready scripts
├── section-07-ecosystem/          # FlameGraphs, JSON output, bcc vs bpftrace
├── section-08-production/         # BTF/CO-RE, verifier, when NOT to use
├── section-09-capstone/           # The slow-API mystery walkthrough
└── lab-environment/               # Optional Vagrant, Packer, cloud-init configs
```

---

## 🧪 Lab environment

The course is built and tested on:

- **Host OS:** Any (Windows, macOS, Linux) — see below
- **Guest OS:** Ubuntu 24.04 LTS
- **Kernel:** 6.x (any 5.15+ works)
- **bpftrace:** ≥ 0.20
- **Recommended VM:** Oracle VirtualBox, 4 GB RAM, 2 vCPUs

**Three options for your lab:**

| Option | Best for | Setup time |
|--------|----------|------------|
| **Oracle VirtualBox + Ubuntu 24.04** | Most students — free, cross-platform, snapshot-friendly | ~30 min |
| **WSL2 (Windows)** | Windows users who want tighter integration | ~15 min |
| **Multipass (macOS/Linux)** | macOS users who want a clean Linux VM | ~10 min |
| **Cloud (Oracle/AWS free tier)** | No local virtualization available | ~10 min |

Detailed walkthrough: [`docs/setup.md`](docs/setup.md)

---

## 📖 How to use this repo

- **Following the course?** Each section folder has a `README.md` listing its lectures and pointing to the relevant scripts. Run the scripts as you watch.
- **Using it as a runbook?** Browse `one-liners/` for ready-to-use scripts organized by problem domain. Each file is self-contained and documented.
- **Debugging production?** Check `section-06-playbooks/` first — those 18 scripts cover the most common Linux performance and security questions.
- **Studying for an interview?** `section-08-production/notes/` has the conceptual deep-dives (BTF, CO-RE, verifier, decision matrices).

---

## 🛡️ Tested bpftrace versions

This repo is pinned to:

- **bpftrace ≥ 0.20** (latest stable)
- **Linux kernel 6.x** (Ubuntu 24.04's default)
- **LLVM 14+** (bpftrace's compilation backend)

Most scripts work on kernel 4.19+ and bpftrace 0.13+, but if you hit a syntax error, the first thing to check is your bpftrace version: `bpftrace --version`.

See [`docs/troubleshooting.md`](docs/troubleshooting.md) for common errors and fixes.

---

## 🤝 Contributing

Students are encouraged to:

1. **Open issues** when a script doesn't work on your distro — distro/kernel compatibility issues help everyone.
2. **Submit PRs** for new one-liners or improved versions of existing scripts.
3. **Share stories** of how you used bpftrace to solve a production issue (anonymized, of course).

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for guidelines.

---

## ⚖️ License

MIT — see [`LICENSE`](LICENSE). Use, modify, redistribute, teach with it. Attribution appreciated.

---

## 🔗 Related resources

- [bpftrace reference guide](https://github.com/iovisor/bpftrace) — the canonical docs
- [Brendan Gregg's bpftrace one-liners](https://www.brendangregg.com/ebpf.html) — the original cheat sheet
- [bcc tools](https://github.com/iovisor/bcc) — when you need to drop down to C
- [libbpf + BPF CO-RE](https://github.com/libbpf/libbpf) — for production-grade BPF programs
- [Awesome eBPF](https://github.com/iovisor/awesome-ebpf) — the curated list of eBPF resources
