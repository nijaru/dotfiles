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
            echo "📦 Updating DNF packages..."
            if command -q dnf
                sudo dnf upgrade -y
                and dnf autoremove -y
                and dnf clean all
            else
                echo "⚠️  DNF not found, skipping"
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

    echo "✅ System updates complete!"
end