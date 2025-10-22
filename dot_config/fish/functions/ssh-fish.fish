#!/usr/bin/env fish
# SSH to remote server with portable Fish config (temporary, auto-cleanup)

function ssh-fish -d "SSH with portable Fish config (temporary session)"
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

    # Create unique temp directory on remote
    set -l remote_tmp (ssh $ssh_args $host 'mktemp -d /tmp/.ssh-fish.XXXXXX' 2>/dev/null | string trim)

    if test -z "$remote_tmp"
        echo "Failed to create temp directory, connecting with default shell..."
        ssh $argv
        return
    end

    # Sync portable config to temp directory
    set -l portable_dir ~/.config/fish/portable

    if command -v rsync >/dev/null 2>&1
        # Use rsync for efficient transfer
        rsync -az $portable_dir/ $host:$remote_tmp/ 2>/dev/null
    else
        # Fallback: tar over SSH
        tar czf - -C $portable_dir . | ssh $ssh_args $host "tar xzf - -C $remote_tmp/" 2>/dev/null
    end

    if test $status -ne 0
        echo "Failed to sync config, connecting with default shell..."
        ssh $ssh_args $host "rm -rf $remote_tmp"
        ssh $argv
        return
    end

    echo "Config synced to $remote_tmp. Connecting with Fish..."

    # Connect with Fish, source portable config, cleanup on exit
    # Using Fish event handler to cleanup temp dir when shell exits
    ssh $ssh_args -t $host "fish --init-command 'source $remote_tmp/config.fish; function __cleanup_ssh_fish --on-event fish_exit; rm -rf $remote_tmp; end'"
end
