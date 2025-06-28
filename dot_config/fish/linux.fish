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

###################
# File Operations
###################

# XDG open command
if command -v xdg-open >/dev/null 2>&1
    alias o="xdg-open"
    alias o.="xdg-open ."
end