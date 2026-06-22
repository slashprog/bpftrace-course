#!/usr/bin/env bash
# install-bpftrace.sh — Just installs bpftrace, no other setup
# Usage: sudo ./install-bpftrace.sh

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Please run as root: sudo ./install-bpftrace.sh"
    exit 1
fi

echo "Installing bpftrace..."

if command -v apt-get &>/dev/null; then
    # Debian/Ubuntu
    apt-get update -qq
    apt-get install -y --no-install-recommends \
        bpftrace \
        linux-headers-$(uname -r) \
        linux-tools-$(uname -r) \
        bpfcc-tools
elif command -v dnf &>/dev/null; then
    # Fedora/RHEL
    dnf install -y bpftrace bpftrace-devel kernel-devel
elif command -v yum &>/dev/null; then
    # Older RHEL/CentOS
    yum install -y bpftrace
elif command -v pacman &>/dev/null; then
    # Arch
    pacman -Sy --noconfirm bpftrace
else
    echo "Could not detect package manager. Please install bpftrace manually:"
    echo "  https://github.com/iovisor/bpftrace/blob/master/INSTALL.md"
    exit 1
fi

echo ""
echo "bpftrace version:"
bpftrace --version
echo ""
echo "Done. Try: sudo bpftrace -e 'kprobe:vfs_read { @[comm] = count(); }'"
