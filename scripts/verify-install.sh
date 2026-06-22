#!/usr/bin/env bash
# verify-install.sh — Sanity check that your bpftrace environment is healthy
# Usage: sudo ./verify-install.sh

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ok()   { echo -e "${GREEN}[PASS]${NC} $*"; }
fail() { echo -e "${RED}[FAIL]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
info() { echo -e "${BLUE}[...]${NC} $*"; }

PASS=0
FAIL=0

check() {
    if eval "$2" &>/dev/null; then
        ok "$1"
        ((PASS++))
    else
        fail "$1"
        ((FAIL++))
    fi
}

echo "============================================"
echo "  bpftrace Lab Environment Check"
echo "============================================"
echo ""

info "System info"
echo "  Hostname:    $(hostname)"
echo "  Kernel:      $(uname -r)"
echo "  Distro:      $(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d= -f2 | tr -d '\"')"
echo ""

info "Checking prerequisites..."
check "Running as root"                    "[[ \$EUID -eq 0 ]]"
check "Kernel 4.19 or newer"               "[[ \$(uname -r | cut -d. -f1) -ge 5 ]] || ([[ \$(uname -r | cut -d. -f1) -eq 4 ]] && [[ \$(uname -r | cut -d. -f2) -ge 19 ]])"
check "bpftrace installed"                 "command -v bpftrace"
check "Kernel headers installed"           "[[ -d /lib/modules/\$(uname -r) ]]"
check "clang installed"                    "command -v clang"
check "llvm installed"                     "command -v llvm-config"
check "jq installed"                       "command -v jq"
check "git installed"                      "command -v git"
echo ""

info "Checking bpftrace version..."
if command -v bpftrace &>/dev/null; then
    bpftrace --version
    ok "bpftrace version: $(bpftrace --version 2>&1 | head -n1)"
    ((PASS++))
fi
echo ""

info "Checking kernel BPF features..."
check "BPF syscall available"              "[[ -e /proc/sys/kernel/unprivileged_bpf_disabled ]]"
check "DebugFS mounted"                    "mount | grep -q debugfs || [[ -d /sys/kernel/debug ]]"
check "BPF filesystem available"           "[[ -d /sys/fs/bpf ]]"
echo ""

info "Running live smoke tests..."
echo -n "  Test 1: Counting syscalls (3s)... "
if timeout 3 bpftrace -e 'kprobe:vfs_read { @[comm] = count(); }' &>/dev/null; then
    echo -e "${GREEN}OK${NC}"
    ((PASS++))
else
    echo -e "${RED}FAILED${NC}"
    ((FAIL++))
fi

echo -n "  Test 2: Tracepoint attachment (3s)... "
if timeout 3 bpftrace -e 'tracepoint:syscalls:sys_enter_open { @[comm] = count(); }' &>/dev/null; then
    echo -e "${GREEN}OK${NC}"
    ((PASS++))
else
    echo -e "${RED}FAILED${NC}"
    ((FAIL++))
fi

echo -n "  Test 3: Map aggregation (3s)... "
if timeout 3 bpftrace -e 'kprobe:vfs_read { @reads = count(); } END { print(@reads); clear(@reads); }' &>/dev/null; then
    echo -e "${GREEN}OK${NC}"
    ((PASS++))
else
    echo -e "${RED}FAILED${NC}"
    ((FAIL++))
fi
echo ""

echo "============================================"
echo "  Results: $PASS passed, $FAIL failed"
echo "============================================"

if [[ $FAIL -gt 0 ]]; then
    warn "Some checks failed. Try running scripts/setup-lab.sh to repair."
    warn "Or see docs/troubleshooting.md for help."
    exit 1
else
    ok "All checks passed. Your lab is ready! 🎉"
    echo ""
    echo "Try your first trace:"
    echo "  sudo bpftrace -e 'kprobe:vfs_read { @[comm] = count(); }'"
    exit 0
fi
