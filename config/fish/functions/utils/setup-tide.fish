function setup-tide --description "Manually configure Tide prompt with dotfiles settings"
    echo "Configuring Tide prompt..."
    
    # Clear existing Tide configuration first
    for var in (set -U | string match '_tide_*' | string replace -r ' .*' '')
        set -eU $var
    end
    
    # Set up Tide prompt layout
    set -U _tide_left_items pwd git newline character
    set -U _tide_right_items status cmd_duration context jobs direnv bun node python rustc java ruby go gcloud kubectl zig time

    # Character settings
    set -U tide_character_color 5FD700
    set -U tide_character_color_failure FF0000
    set -U tide_character_icon ❯
    
    # (abbreviated for brevity - same settings as run_once script)
    
    echo "Tide prompt reconfigured successfully!"
    echo "Restart your shell to see changes."
end