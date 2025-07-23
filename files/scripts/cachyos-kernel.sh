#!/usr/bin/env bash
set -oue pipefail

log() {
  echo "=== $* ==="
}

log "Installing cachyos kernel"

dnf5 -y copr enable bieszczaders/kernel-cachyos-lto

dnf5 -y remove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-devel-matched
dnf5 -y install akmods kernel-cachyos-lto kernel-cachyos-lto-modules kernel-cachyos-lto-core \
	kernel-cachyos-lto-devel-matched

dnf5 -y copr disable bieszczaders/kernel-cachyos-lto
setsebool -P domain_kernel_load_modules on
