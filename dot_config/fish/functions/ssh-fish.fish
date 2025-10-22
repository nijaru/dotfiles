#!/usr/bin/env fish
# SSH to remote server with portable Fish config

function ssh-fish -d "SSH with portable Fish config"
    # Parse SSH args to get hostname (simple approach)
    set -l host $argv[-1]
    set -l ssh_args $argv[1..-2]

    if test (count $argv) -lt 1
        echo "Usage: ssh-fish [ssh-options] hostname"
        return 1
    end

    # Check if remote has Fish
    echo "Checking for Fish on $host..."
    if not ssh $ssh_args $host 'command -v fish' >/dev/null 2>&1
        echo "Fish not installed on $host, falling back to regular SSH"
        ssh $argv
        return
    end

    echo "Fish found! Syncing portable config..."

    # Create remote config directory
    ssh $ssh_args $host 'mkdir -p ~/.config/fish' >/dev/null 2>&1

    # Sync portable config (use rsync if available, otherwise tar+ssh)
    set -l portable_dir ~/.config/fish/portable

    if command -v rsync >/dev/null 2>&1
        # Use rsync for efficient transfer
        rsync -az --delete $portable_dir/ $host:~/.config/fish/ 2>/dev/null
    else
        # Fallback: tar over SSH
        tar czf - -C $portable_dir . | ssh $ssh_args $host 'tar xzf - -C ~/.config/fish/' 2>/dev/null
    end

    if test $status -eq 0
        echo "Config synced. Connecting with Fish..."
        # Connect with Fish, load portable config
        ssh $ssh_args -t $host 'fish'
    else
        echo "Failed to sync config, connecting with default shell..."
        ssh $argv
    end
end
