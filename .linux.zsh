#!/usr/bin/env zsh

###################
# System Management
###################
# Systemd service management
alias sc="systemctl"
alias scs="systemctl status"
alias scr="systemctl restart"
alias sct="systemctl start"
alias scp="systemctl stop"
alias sce="systemctl enable"
alias scd="systemctl disable"
alias scl="systemctl list-units"
alias scf="systemctl --failed"           # Show failed units
alias scu="systemctl --user"            # User services
alias scdr="systemctl daemon-reload"    # Reload systemd

# Journald log management
alias jc="journalctl"
alias jcf="journalctl -f"               # Follow logs
alias jce="journalctl -e"               # Jump to end
alias jct="journalctl --since today"    # Today's logs
alias jcb="journalctl -b"               # Current boot
alias jcc="sudo journalctl --vacuum-time=7d"  # Clean old logs

###################
# Package Management
###################
# Debian/Ubuntu
if command -v apt >/dev/null; then
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
    alias aptkey="sudo apt-key"
    alias apthold="sudo apt-mark hold"
    alias aptunhold="sudo apt-mark unhold"

    # Update system
    alias update="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && rustup update && pipx upgrade-all && z4h update"
fi

# RHEL/Fedora
if command -v dnf >/dev/null; then
    # Basic operations
    alias dnfu="dnf check-update"
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

    # Update system
    alias update="sudo dnf upgrade -y && sudo dnf autoremove -y && rustup update && pipx upgrade-all && z4h update"
fi

###################
# System Operations
###################
# Basic commands
alias open="xdg-open"
alias o="xdg-open"
alias clip="xclip -selection clipboard"
alias paste="xclip -selection clipboard -o"

# System monitoring
alias cpu="top -o %CPU"
alias mem="free -h"
alias disk="df -h"
alias io="iostat -x 1"
alias net="ss -tulanp"
alias who="w"
alias top="btop"  # Modern top replacement

# System maintenance
alias cleancache="sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches"
alias cleanjournal="sudo journalctl --vacuum-time=7d"
alias cleantmp="sudo rm -rf /tmp/*"

###################
# Network Management
###################
# NetworkManager
alias wifi="nmcli device wifi"
alias wific="nmcli device wifi connect"
alias wifil="nmcli device wifi list"
alias conn="nmcli connection"
alias netrestart="sudo systemctl restart NetworkManager"

# Network troubleshooting
alias ping="ping -c 5"              # Ping with count
alias ports="ss -tulanp"            # Show listening ports
alias ips="ip -c a"                 # Show IP addresses
alias dns="resolvectl status"       # Show DNS settings
alias tracepath="tracepath -b"      # Better traceroute
alias speedtest="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -"

###################
# System Paths
###################
alias conf="cd /etc"
alias logs="cd /var/log"
alias sysd="cd /etc/systemd/system"
alias srv="cd /srv"

# Ensure PATH is clean
typeset -U PATH path
