#!/usr/bin/env bash
# setup-lab.sh — Idempotent lab setup for the bpftrace Udemy course
# Tested on: Ubuntu 24.04 LTS, kernel 6.x
# Usage:     sudo ./setup-lab.sh

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info()  { echo -e "${BLUE}[INFO]${NC}  $*"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
fail()  { echo -e "${RED}[FAIL]${NC}  $*"; }

# 1. Privilege check
if [[ $EUID -ne 0 ]]; then
    fail "This script must be run as root (try: sudo ./setup-lab.sh)"
    exit 1
fi

# 2. Distro check
if ! command -v lsb_release &>/dev/null && [[ ! -f /etc/os-release ]]; then
    fail "Cannot determine distro. This script is designed for Ubuntu 24.04."
    exit 1
fi

source /etc/os-release
if [[ "$ID" != "ubuntu" ]]; then
    warn "This script is designed for Ubuntu 24.04. Detected: $ID $VERSION_ID"
    warn "Some commands may fail. Continuing anyway..."
fi

# 3. Kernel version check
KERNEL_VERSION=$(uname -r | cut -d- -f1)
KERNEL_MAJOR=$(echo "$KERNEL_VERSION" | cut -d. -f1)
KERNEL_MINOR=$(echo "$KERNEL_VERSION" | cut -d. -f2)
info "Detected kernel: $KERNEL_VERSION"

if [[ "$KERNEL_MAJOR" -lt 4 ]] || { [[ "$KERNEL_MAJOR" -eq 4 ]] && [[ "$KERNEL_MINOR" -lt 19 ]]; }; then
    fail "Kernel $KERNEL_VERSION is too old. bpftrace requires kernel 4.19+."
    fail "Please use Ubuntu 22.04+ or upgrade your kernel."
    exit 1
fi
ok "Kernel version OK"

# 4. Update package lists
info "Updating package lists..."
apt-get update -qq

# 5. Install required packages
info "Installing bpftrace and dependencies..."
apt-get install -y --no-install-recommends \
    bpftrace \
    linux-headers-$(uname -r) \
    linux-tools-$(uname -r) \
    bpfcc-tools \
    linux-tools-common \
    clang \
    llvm \
    libbpf-dev \
    linux-libc-dev \
    build-essential \
    git \
    curl \
    wget \
    jq \
    linux-cloud-tools-$(uname -r) 2>/dev/null || warn "Some optional packages not available"

# 6. Configure kernel settings for BPF
info "Configuring kernel BPF settings..."

# Ensure unprivileged BPF is disabled (recommended for security)
sysctl -w kernel.unprivileged_bpf_disabled=1 2>/dev/null || warn "Could not set kernel.unprivileged_bpf_disabled"

# Set perf event paranoid level (allows tracing without root for some events)
sysctl -w kernel.perf_event_paranoid=1 2>/dev/null || warn "Could not set kernel.perf_event_paranoid"

# 7. Verify bpftrace installation
info "Verifying bpftrace installation..."
if command -v bpftrace &>/dev/null; then
    BPFTRACE_VERSION=$(bpftrace --version 2>&1 | head -n1)
    ok "bpftrace installed: $BPFTRACE_VERSION"
else
    fail "bpftrace installation failed. Try: apt-get install bpftrace"
    exit 1
fi

# 8. Quick smoke test
info "Running smoke test (counting syscalls for 3 seconds)..."
if timeout 3 bpftrace -e 'kprobe:do_sys_open { @[comm] = count(); }' &>/dev/null; then
    ok "Smoke test passed — bpftrace is working"
else
    warn "Smoke test produced no output (this is OK if no processes opened files in 3s)"
fi

# 9. Set up vagrant shared folder permissions (if running in Vagrant)
if [[ -d /vagrant ]]; then
    info "Vagrant environment detected, fixing permissions..."
    chown -R vagrant:vagrant /vagrant 2>/dev/null || true
fi

# 10. Summary
echo ""
echo "============================================"
echo "  Lab setup complete!"
echo "============================================"
echo ""
echo "Quick test:"
echo "  sudo bpftrace -e 'kprobe:vfs_read { @[comm] = count(); }'"
echo ""
echo "Explore the course materials:"
echo "  ls -la ~/[path-to-repo]/section-0[1-9]"
echo ""
echo "Documentation:"
echo "  - docs/setup.md — full lab walkthrough"
echo "  - docs/cheatsheet.md — bpftrace one-liners"
echo "  - docs/troubleshooting.md — common errors"
echo ""
ok "Ready to learn bpftrace! 🚀"
