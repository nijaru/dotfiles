#!/usr/bin/env fish
# Linux-specific configuration and utilities for Fish shell

###################
# System Management
###################

# Systemd service management
if command -v systemctl >/dev/null 2>&1
    # Service control
    abbr --add sc "systemctl"
    abbr --add scs "systemctl status"
    abbr --add scr "systemctl restart"
    abbr --add sct "systemctl start"
    abbr --add scp "systemctl stop"
    abbr --add sce "systemctl enable"
    abbr --add scd "systemctl disable"
    abbr --add scl "systemctl list-units"
    abbr --add scf "systemctl --failed"
    abbr --add scu "systemctl --user"
    abbr --add scdr "systemctl daemon-reload"

    # Journal management
    abbr --add jc "journalctl"
    abbr --add jcf "journalctl -f"                    # Follow logs
    abbr --add jce "journalctl -e"                    # Jump to end
    abbr --add jct "journalctl --since today"         # Today's logs
    abbr --add jcb "journalctl -b"                    # Current boot
    abbr --add jcc "sudo journalctl --vacuum-time=7d" # Clean old logs
end

###################
# Package Management
###################

# RHEL/Fedora specific
if command -v dnf >/dev/null 2>&1
    # Basic operations
    abbr --add dnfu "sudo dnf check-update"
    abbr --add dnfup "sudo dnf upgrade"
    abbr --add dnfi "sudo dnf install"
    abbr --add dnfx "sudo dnf remove"
    abbr --add dnfax "sudo dnf autoremove"

    # Search and information
    abbr --add dnfs "dnf search"
    abbr --add dnfin "dnf info"
    abbr --add dnfl "dnf list installed"
    abbr --add dnfd "dnf deplist"
    abbr --add dnfh "dnf history"

    # System maintenance
    abbr --add dnfc "sudo dnf clean all"
    abbr --add dnffix "sudo dnf distro-sync"
    abbr --add dnfgr "sudo dnf grouplist"
    abbr --add dnfgi "sudo dnf groupinstall"
end

# Debian/Ubuntu specific
if command -v apt >/dev/null 2>&1
    # Basic operations
    abbr --add aptu "sudo apt update"
    abbr --add aptup "sudo apt upgrade"
    abbr --add apti "sudo apt install"
    abbr --add aptx "sudo apt remove"
    abbr --add aptxx "sudo apt purge"
    abbr --add aptax "sudo apt autoremove"

    # Search and information
    abbr --add apts "apt search"
    abbr --add aptin "apt show"
    abbr --add aptl "apt list --installed"
    abbr --add aptd "apt depends"
    abbr --add aptrd "apt rdepends"

    # System maintenance
    abbr --add aptc "sudo apt clean && sudo apt autoclean"
    abbr --add aptfix "sudo apt --fix-broken install"
    abbr --add apthold "sudo apt-mark hold"
    abbr --add aptunhold "sudo apt-mark unhold"
end

###################
# File Operations
###################

# XDG open command
if command -v xdg-open >/dev/null 2>&1
    abbr --add o "xdg-open"
    abbr --add o. "xdg-open ."
end

###################
# Container Management
###################

# Ollama CLI via podman
if command -v podman >/dev/null 2>&1
    alias ollama "sudo podman exec -it ollama ollama"
end

###################
# SSH Agent Setup
###################

# Ensure SSH agent is working with keys loaded
if status is-interactive
    # For GNOME desktop, use GNOME Keyring's SSH agent
    if set -q DESKTOP_SESSION; and string match -q "*gnome*" $DESKTOP_SESSION
        # GNOME Keyring should handle SSH automatically
        # Just ensure the key is added if not present
        ssh-add -l >/dev/null 2>&1
        if test $status -eq 1
            # No keys loaded, add with keyring support
            ssh-add ~/.ssh/id_ed25519 2>/dev/null
        end
    else
        # Fallback for non-GNOME environments
        # Check if ssh-add can list keys (agent working + keys loaded)
        if not ssh-add -l >/dev/null 2>&1
            eval (ssh-agent -c)
            ssh-add ~/.ssh/id_ed25519 2>/dev/null
        end
    end
end