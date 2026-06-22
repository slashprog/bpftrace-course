# Lab Setup Guide

This document walks you through getting a working bpftrace lab environment. **The recommended path is Oracle VirtualBox + Ubuntu 24.04 LTS** — it's free, cross-platform, and lets you snapshot/restore easily when experimenting.

---

## Recommended setup: VirtualBox + Ubuntu 24.04

### Step 1 — Install VirtualBox

| Host OS | How to install |
|---------|----------------|
| **Windows** | Download from [virtualbox.org](https://www.virtualbox.org/wiki/Downloads), run installer |
| **macOS** | Download from [virtualbox.org](https://www.virtualbox.org/wiki/Downloads), run DMG |
| **Linux** | `sudo apt install virtualbox` (Ubuntu/Debian) or use your distro's package manager |

### Step 2 — Download Ubuntu 24.04 LTS ISO

Get the desktop ISO from [releases.ubuntu.com/24.04](https://releases.ubuntu.com/24.04/) (server ISO also works if you prefer a CLI-only setup — the course doesn't require a graphical environment).

### Step 3 — Create the VM

In VirtualBox:

1. Click **New** → Name: `bpftrace-lab`, Type: **Linux**, Version: **Ubuntu (64-bit)**
2. **Memory:** 4096 MB (4 GB) minimum, 8192 MB recommended
3. **Hard disk:** Create a virtual hard disk now → VDI → Dynamically allocated → 50 GB
4. Mount the Ubuntu ISO and start the VM
5. Walk through the Ubuntu installer (default settings are fine)
6. Reboot, install Guest Additions for better screen resolution

### Step 4 — Install bpftrace

Open a terminal in the VM:

```bash
sudo apt-get update
sudo apt-get install -y bpftrace linux-headers-$(uname -r) linux-tools-$(uname -r) bpfcc-tools jq
```

Or just run the lab setup script from this repo:

```bash
cd /path/to/this/repo
sudo ./scripts/setup-lab.sh
sudo ./scripts/verify-install.sh
```

### Step 5 — Verify it works

```bash
sudo bpftrace -e 'kprobe:vfs_read { @[comm] = count(); }'
```

You should see output like:

```
Attaching 1 probe...
^C

@[ls]: 4
@[systemd]: 12
@[firefox]: 23
```

Hit **Ctrl-C** to stop. If you see process names with counts, you're ready to go.

---

## Alternative 1: WSL2 (Windows)

WSL2 works for bpftrace, with a few caveats.

### Install WSL2

```powershell
# In PowerShell as Administrator
wsl --install
# Then install Ubuntu 24.04 from the Microsoft Store
```

### Install bpftrace

```bash
# Inside WSL2
sudo apt-get update
sudo apt-get install -y bpftrace linux-headers-$(uname -r) linux-tools-$(uname -r) bpfcc-tools
```

### WSL2 caveats

- **Systemd must be enabled** in `/etc/wsl.conf` for some bpftrace features:
  ```ini
  [boot]
  systemd=true
  ```
  Then restart WSL: `wsl --shutdown` from PowerShell.
- **Kernel version is Windows-controlled** — check with `uname -r` inside WSL2. If it's too old, update Windows.
- **No kernel modules** — WSL2 doesn't support loading custom kernel modules, but you don't need them for bpftrace.

---

## Alternative 2: Multipass (macOS / Linux)

Multipass is a lightweight VM manager from Canonical. Great for macOS users.

```bash
# Install on macOS
brew install multipass

# Or on Linux
sudo snap install multipass

# Launch Ubuntu 24.04
multipass launch 24.04 --name bpftrace-lab --cpus 2 --memory 4G --disk 50G

# Open a shell
multipass shell bpftrace-lab

# Install bpftrace inside
sudo apt-get update
sudo apt-get install -y bpftrace linux-headers-$(uname -r) linux-tools-$(uname -r) bpfcc-tools
```

---

## Alternative 3: Cloud (Oracle Cloud / AWS free tier)

If you can't run VMs locally, a cloud instance works fine. Oracle Cloud has a true "always free" tier that's the most generous.

```bash
# After creating an Ubuntu 24.04 instance and SSHing in:
sudo apt-get update
sudo apt-get install -y bpftrace linux-headers-$(uname -r) linux-tools-$(uname -r) bpfcc-tools
```

**Cloud caveats:**

- **Latency:** Live demos feel slower over SSH. Use `tmux` or `screen` to avoid losing work.
- **Cost trap:** Always-free tiers have limits. Set billing alerts.
- **Security:** Your scripts run on a remote host. Don't accidentally trace credentials you wouldn't want exposed.

---

## ⚙️ Recommended VM settings

For the smoothest experience in VirtualBox:

| Setting | Value |
|---------|-------|
| CPUs | 2 (4 if you can spare) |
| RAM | 4096 MB (8192 MB for headroom) |
| Disk | 50 GB dynamically allocated |
| Network | NAT (default) — Bridged if you want to SSH in from the host |
| Display | 128 MB video memory, Enable 3D Acceleration |
| Shared Clipboard | Bidirectional |
| Drag'n'Drop | Bidirectional |

Take a snapshot once setup is done: **Machine → Take Snapshot → "clean install"**. You can roll back any time something goes wrong.

---

## 🐛 Common setup problems

### "bpftrace: command not found"

```bash
sudo apt-get update
sudo apt-get install bpftrace
```

### "ERROR: failed to attach kprobe"

Your kernel is too old or your kernel headers don't match your running kernel. Check:

```bash
uname -r                               # Running kernel
ls /lib/modules/                        # Available kernel modules
```

If they don't match, reboot into the newer kernel or install matching headers.

### "Permission denied" running bpftrace

bpftrace needs root. Use `sudo`, or add yourself to the `bpf` group (advanced — security tradeoffs).

### "kernel.unprivileged_bpf_disabled = 1" warning

This is **good**. It means unprivileged users can't run BPF programs. You need root to run bpftrace, which is the right default.

### "Failed to load BPF program: Operation not permitted"

You're not running as root, or your kernel has lockdown mode enabled. Check `cat /proc/keys` and your distro's lockdown docs.

---

## Next steps

Once your lab is running:

1. Run `./scripts/verify-install.sh` to confirm everything works
2. Try `bpftrace one-liners/syscalls/count-syscalls.bt` to see your first trace
3. Move on to Section 1, lecture 1.11 — the "instant gratification" demo
4. See [`docs/cheatsheet.md`](cheatsheet.md) for the one-liner library

Happy tracing! 🔍
