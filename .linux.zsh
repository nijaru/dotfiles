#!/usr/bin/env zsh

###################
# System Management
###################
# Systemd
alias sc="systemctl"
alias scs="systemctl status"
alias scr="systemctl restart"
alias sct="systemctl start"
alias scp="systemctl stop"
alias sce="systemctl enable"
alias scd="systemctl disable"
alias scl="systemctl list-units"
alias jc="journalctl"
alias jcf="journalctl -f"
alias jce="journalctl -e"

# System commands
alias open="xdg-open"
alias o="xdg-open"
alias clip="xclip -selection clipboard"
alias paste="xclip -selection clipboard -o"

###################
# Package Management
###################
# Debian/Ubuntu
if command -v apt >/dev/null; then
    alias up="sudo apt update && sudo apt upgrade"
    alias aptu="sudo apt update"
    alias aptup="sudo apt upgrade"
    alias aptupy="sudo apt upgrade -y"
    alias apti="sudo apt install"
    alias aptx="sudo apt remove"
    alias aptxx="sudo apt purge"
    alias aptax="sudo apt autoremove"
    alias aptin="apt show"
    alias aptse="apt search"
fi

# RHEL/Fedora
if command -v dnf >/dev/null; then
    alias up="sudo dnf check-update && sudo dnf upgrade"
    alias dnfu="dnf check-update"
    alias dnfup="sudo dnf upgrade"
    alias dnfupy="sudo dnf upgrade -y"
    alias dnfupr="sudo dnf upgrade --refresh"
    alias dnfi="sudo dnf install"
    alias dnfx="sudo dnf remove"
    alias dnfax="sudo dnf autoremove"
    alias dnfin="dnf info"
    alias dnfs="dnf search"
fi

###################
# Flatpak Management
###################
if command -v flatpak >/dev/null; then
    alias fp="flatpak"
    alias fpi="flatpak install"
    alias fpx="flatpak uninstall"
    alias fpu="fp update"
    alias fpuy="fp update -y"
fi

###################
# System Paths
###################
alias conf="cd /etc"
alias logs="cd /var/log"
alias sysd="cd /etc/systemd/system"
alias srv="cd /srv"

###################
# System Information
###################
alias sysinfo="inxi -Fxxxz"
alias temp="sensors"
alias ports="ss -tulanp"
alias services="systemctl list-units --type=service"

###################
# Network Management
###################
alias wifi="nmcli device wifi"
alias connections="nmcli connection"
alias netrestart="sudo systemctl restart NetworkManager"

###################
# Power Management
###################
alias suspend="systemctl suspend"
alias poweroff="systemctl poweroff"
alias reboot="systemctl reboot"
