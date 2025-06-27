#!/usr/bin/env fish
# Linux-specific configuration and utilities for Fish shell

###################
# System Management
###################

# Systemd service management
if command -v systemctl >/dev/null 2>&1
    # Service control
    alias sc="systemctl"
    alias scs="systemctl status"
    alias scr="systemctl restart"
    alias sct="systemctl start"
    alias scp="systemctl stop"
    alias sce="systemctl enable"
    alias scd="systemctl disable"
    alias scl="systemctl list-units"
    alias scf="systemctl --failed"
    alias scu="systemctl --user"
    alias scdr="systemctl daemon-reload"

    # Journal management
    alias jc="journalctl"
    alias jcf="journalctl -f"                    # Follow logs
    alias jce="journalctl -e"                    # Jump to end
    alias jct="journalctl --since today"         # Today's logs
    alias jcb="journalctl -b"                    # Current boot
    alias jcc="sudo journalctl --vacuum-time=7d" # Clean old logs
end

###################
# Package Management
###################

# Debian/Ubuntu specific
if command -v apt >/dev/null 2>&1
    # Basic operations
    alias aptu="sudo apt update"
    alias aptup="sudo apt upgrade"
    alias apti="sudo apt install"
    alias aptx="sudo apt remove"
    alias aptxx="sudo apt purge"
    alias aptax="sudo apt autoremove"

    # Search and information
    alias apts="apt search"
    alias aptin="apt show"
    alias aptl="apt list --installed"
    alias aptd="apt depends"
    alias aptrd="apt rdepends"

    # System maintenance
    alias aptc="sudo apt clean && sudo apt autoclean"
    alias aptfix="sudo apt --fix-broken install"
    alias apthold="sudo apt-mark hold"
    alias aptunhold="sudo apt-mark unhold"
end

# RHEL/Fedora specific
if command -v dnf >/dev/null 2>&1
    # Basic operations
    alias dnfu="sudo dnf check-update"
    alias dnfup="sudo dnf upgrade"
    alias dnfi="sudo dnf install"
    alias dnfx="sudo dnf remove"
    alias dnfax="sudo dnf autoremove"

    # Search and information
    alias dnfs="dnf search"
    alias dnfin="dnf info"
    alias dnfl="dnf list installed"
    alias dnfd="dnf deplist"
    alias dnfh="dnf history"

    # System maintenance
    alias dnfc="sudo dnf clean all"
    alias dnffix="sudo dnf distro-sync"
    alias dnfgr="sudo dnf grouplist"
    alias dnfgi="sudo dnf groupinstall"
end

###################
# File System Operations
###################

# Mount operations
alias mount-smb="sudo mount -t cifs"
alias mount-nfs="sudo mount -t nfs"

# Disk utilities
alias lsblk="lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT"
alias df="df -hT" # Show filesystem type
if command -v ncdu >/dev/null 2>&1
    alias ncdu="ncdu --color dark" # Disk usage analyzer
end

###################
# Process Management
###################

# Process viewing
alias pstree="pstree -p" # Show PIDs
alias watch="watch -c"   # Colorized watch
alias fuser="fuser -v"   # Verbose fuser

# System information
alias cpu-info="cat /proc/cpuinfo"
alias mem-info="cat /proc/meminfo"
if command -v inxi >/dev/null 2>&1
    alias sys-info="inxi -Fxz" # Detailed system information
end
alias kernel="uname -r"
alias dmesg="sudo dmesg -T" # Human readable timestamps

###################
# Network Management
###################

# NetworkManager
if command -v nmcli >/dev/null 2>&1
    alias nmr="sudo systemctl restart NetworkManager"
    alias nm-list="nmcli device wifi list"
    alias nm-connect="nmcli device wifi connect"
    alias nm-show="nmcli connection show"
end

# Firewall management
if command -v ufw >/dev/null 2>&1
    alias fw="sudo ufw"
    alias fw-list="sudo ufw status numbered"
    alias fw-reload="sudo ufw reload"
else if command -v firewall-cmd >/dev/null 2>&1
    alias fw="sudo firewall-cmd"
    alias fw-list="sudo firewall-cmd --list-all"
    alias fw-reload="sudo firewall-cmd --reload"
end

###################
# Display Management
###################

# X11 specific
if command -v xrandr >/dev/null 2>&1
    alias displays="xrandr --query"
    alias display-reset="xrandr --auto"
end

# Wayland specific
if command -v wlr-randr >/dev/null 2>&1
    alias wl-displays="wlr-randr"
end

###################
# Audio Management
###################

# PulseAudio/Pipewire
if command -v pactl >/dev/null 2>&1
    alias audio-restart="systemctl --user restart pulseaudio.service"
    alias audio-list="pactl list sinks"
    alias audio-inputs="pactl list sources"
end

###################
# Security
###################

# AppArmor/SELinux
if command -v aa-status >/dev/null 2>&1
    alias aa-reload="sudo systemctl reload apparmor"
    alias aa-list="sudo aa-status"
else if command -v setenforce >/dev/null 2>&1
    alias se-status="sestatus"
    alias se-list="semanage boolean -l"
end

###################
# Quick Directory Access
###################

# System directories
alias conf="cd /etc"
alias logs="cd /var/log"
alias sysd="cd /etc/systemd/system"
alias systemd="cd /etc/systemd"
alias services="cd /etc/systemd/system"

# Web server configs
alias apache="cd /etc/apache2"
alias nginx="cd /etc/nginx"

###################
# File Operations
###################

# XDG open command
if command -v xdg-open >/dev/null 2>&1
    alias o="xdg-open"
    alias o.="xdg-open ."
end