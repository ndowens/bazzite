#!/usr/bin/env bash

set -ouex pipefail

enable_copr() {
	dnf -y copr enable $1
}

enable_copr solopasha/hyprland
enable_copr erikreider/SwayNotificationCenter
dnf5 -y install \
    brightnessctl \
    cliphist \
    clipman \
    figlet \
    fuse \
    google-noto-fonts-all \
    grim \
    grimblast \
    gtk4 \
    gum \
    gvfs \
    hyprcursor \
    hyprgraphics \
    hypridle \
    hyprland \
    hyprland-qt-support \
    hyprland-qtutils \
    hyprland-uwsm \
    hyprlock \
    hyprpaper \
    hyprpicker \
    hyprpolkitagent \
    hyprsunset \
    hyprsysteminfo \
    ImageMagick \
    jq \
    kitty \
    libadwaita \
    libnotify \
    network-manager-applet \
    nm-connection-editor \
    nwg-dock-hyprland \
    nwg-drawer \
    nwg-look \
    papirus-icon-theme \
    pavucontrol \
    python3-gobject \
    python3-pip \
    python3-screeninfo \
    qt6ct \
    rofi-wayland \
    slurp \
    SwayNotificationCenter \
    swaync \
    swww \
    tumbler \
    uwsm \
    waybar \
    wdisplays \
    wl-clipboard \
    wlogout \
    xclip \
    xdg-desktop-portal-hyprland
