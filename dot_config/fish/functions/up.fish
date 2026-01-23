function up --description "Update all package managers and tools"
    set -l platform (uname)

    echo "🔄 Starting system updates..."

    # Platform-specific package manager updates
    switch $platform
        case Darwin
            echo "📦 Updating Homebrew..."
            if command -q brew
                brew update
                and brew upgrade
                and brew cleanup
                and brew autoremove
            else
                echo "⚠️  Homebrew not found, skipping"
            end

        case Linux
            # Try distro-specific package managers
            if command -q dnf
                echo "📦 Updating DNF packages..."
                sudo dnf upgrade -y --refresh
                and sudo dnf autoremove -y
                and sudo dnf clean all
            else if command -q apt
                echo "📦 Updating APT packages..."
                sudo apt update
                and sudo apt upgrade -y
                and sudo apt autoremove -y
                and sudo apt clean
            else if command -q pacman
                echo "📦 Updating Pacman packages..."
                sudo pacman -Syu --noconfirm
                and sudo pacman -Sc --noconfirm
            else
                echo "⚠️  No supported package manager found"
            end

        case '*'
            echo "⚠️  Unknown platform: $platform"
    end

    # mise (version manager)
    echo "🔧 Updating mise tools..."
    if command -q mise
        mise up
        and mise prune
    else
        echo "⚠️  mise not found, skipping"
    end

    # uv (Python package manager)
    echo "🐍 Updating uv tools..."
    if command -q uv
        uv tool upgrade --all
    else
        echo "⚠️  uv not found, skipping"
    end

    # pixi (conda package manager - for Mojo, scientific tools)
    echo "📦 Updating pixi global environments..."
    if command -q pixi
        pixi global update
    else
        echo "⚠️  pixi not found, skipping"
    end

    # Rust toolchain
    echo "🦀 Updating Rust toolchain..."
    if command -q rustup
        rustup update
    else
        echo "⚠️  rustup not found, skipping"
    end

    # Bun
    echo "🥟 Updating Bun..."
    if command -q bun
        bun upgrade
        and bun update -g
    else
        echo "⚠️  bun not found, skipping"
    end

    # fisher (Fish plugin manager)
    echo "🐟 Updating fisher plugins..."
    if type -q fisher
        fisher update
    else
        echo "⚠️  fisher not found, skipping"
    end

    # chezmoi (dotfiles)
    echo "🏠 Updating dotfiles..."
    if command -q chezmoi
        chezmoi update --force
    else
        echo "⚠️  chezmoi not found, skipping"
    end

    # Linux-specific: flatpak
    if test "$platform" = Linux
        if command -q flatpak
            echo "📦 Updating flatpak apps..."
            sudo flatpak update -y
        end
    end

    echo "✅ System updates complete!"
end