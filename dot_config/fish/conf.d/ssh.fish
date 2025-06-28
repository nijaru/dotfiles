# SSH agent configuration - Linux only
# macOS handles SSH agent automatically via launchd and SSH config UseKeychain
if test (uname) != "Darwin"
    # Linux: Use systemd-managed persistent agent
    set -gx SSH_AUTH_SOCK "$HOME/.ssh/agent.sock"
end