#!/usr/bin/env bash
set -oue pipefail

trap '[[ $BASH_COMMAND != echo* ]] && [[ $BASH_COMMAND != log* ]] && echo "+ $BASH_COMMAND"' DEBUG

log() {
  echo "=== $* ==="
}

# Workaround to allow installing nix with composefs
mkdir /nix

# RPM packages list
declare -A RPM_PACKAGES=(
  ["fedora"]="\
    bazaar \
    bchunk \
    fuse-btfs \
    fuse-devel \
    fuse3-devel \
    fzf \
    gparted \
    gwenview \
    keepassxc \
    kcalc \
    ksystemlog \
    krunner-bazaar \
    libcap-ng \
    libcap-ng-devel \
    procps-ng \
    procps-ng-devel \
    neovim \
    plasma-workspace-x11 \
    qemu-kvm \
    scx-scheds \
    thefuck \
    util-linux \
    virt-manager \
    virt-viewer \
    zsh-autosuggestions \
    zsh"

  ["terra"]="\
    hack-nerd-fonts \
    ubuntu-nerd-fonts \
    ubuntumono-nerd-fonts \
    ubuntusans-nerd-fonts"


  ["fedora-multimedia"]="\
    mpv" 

  ["docker-ce"]="\
    containerd.io \
    docker-buildx-plugin \
    docker-ce \
    docker-ce-cli \
    docker-compose-plugin"

  ["cloudflare-warp"]="cloudflare-warp"
  ["vscode"]="code"
  ["cloudflared"]="cloudflared"

 )
 
log "Remove waydroid"
dnf5 -y remove waydroid waydroid-selinux

log "Installing RPM packages"
mkdir -p /var/opt
for repo in "${!RPM_PACKAGES[@]}"; do
  read -ra pkg_array <<<"${RPM_PACKAGES[$repo]}"
  if [[ $repo == copr:* ]]; then
    # Handle COPR packages
    copr_repo=${repo#copr:}
    dnf5 -y copr enable "$copr_repo"
    dnf5 -y install "${pkg_array[@]}"
    dnf5 -y copr disable "$copr_repo"
  else
    # Handle regular packages
    [[ $repo != "fedora" ]] && enable_opt="--enable-repo=$repo" || enable_opt=""
    cmd=(dnf5 -y install)
    [[ -n "$enable_opt" ]] && cmd+=("$enable_opt")
    cmd+=("${pkg_array[@]}")
    "${cmd[@]}"
  fi
done

log "Hide incompatible Bazzite just recipes"
for recipe in "install-coolercontrol" "install-openrgb"; do
  if ! grep -l "^$recipe:" /usr/share/ublue-os/just/*.just | grep -q .; then
    echo "Error: Recipe $recipe not found in any just file"
    exit 1
  fi
  sed -i "s/^$recipe:/_$recipe:/" /usr/share/ublue-os/just/*.just
done

log "Build process completed"
