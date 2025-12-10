#!/usr/bin/env fish
# Development environment configuration for Fish shell

###############################################################################
# General Development
###############################################################################
# modular / mojo / magic
if command -v magic >/dev/null 2>&1
    abbr --add m "magic"
end

# hhg (semantic code search)
if command -v hhg >/dev/null 2>&1
    abbr --add hhgb "hhg build"

    # Sync .hhg index between machines via rsync
    # Usage: sync-hhg <src-host> <dest-host> [path]
    # Example: sync-hhg fedora apple ~/github/myproject
    # If path omitted, syncs current directory's .hhg
    # Uses $USER for remote username, or set HHG_SYNC_USER to override
    function sync-hhg
        if test (count $argv) -lt 2
            echo "Usage: sync-hhg <src-host> <dest-host> [path]"
            echo "Example: sync-hhg fedora apple ~/github/project"
            return 1
        end

        set -l src $argv[1]
        set -l dest $argv[2]
        set -l dir (test (count $argv) -ge 3; and echo $argv[3]; or pwd)
        set -l user (set -q HHG_SYNC_USER; and echo $HHG_SYNC_USER; or echo $USER)
        set -l localhost (hostname -s)

        # Convert to path relative to home
        set -l rel_path (string replace -r "^$HOME/?" "" (realpath $dir 2>/dev/null; or echo $dir))
        set -l rel_path (string replace -r "^~/" "" $rel_path)

        echo "Syncing .hhg: $src:~/$rel_path/.hhg → $dest:~/$rel_path/.hhg"

        # Use temp dir as intermediary
        set -l tmp_dir (mktemp -d)

        # Pull from source (local or remote)
        if string match -qi $src $localhost
            if not rsync -az "$HOME/$rel_path/.hhg/" "$tmp_dir/"
                echo "Failed to read local .hhg"
                rm -rf $tmp_dir
                return 1
            end
        else
            if not rsync -az --info=progress2 "$user@$src:$rel_path/.hhg/" "$tmp_dir/"
                echo "Failed to fetch .hhg from $src"
                rm -rf $tmp_dir
                return 1
            end
        end

        # Push to destination (local or remote)
        if string match -qi $dest $localhost
            mkdir -p "$HOME/$rel_path"
            if not rsync -az "$tmp_dir/" "$HOME/$rel_path/.hhg/"
                echo "Failed to write local .hhg"
                rm -rf $tmp_dir
                return 1
            end
        else
            if not rsync -az --info=progress2 "$tmp_dir/" "$user@$dest:$rel_path/.hhg/"
                echo "Failed to push .hhg to $dest"
                rm -rf $tmp_dir
                return 1
            end
        end

        rm -rf $tmp_dir
        echo "Done"
    end
end

###############################################################################
# mise
###############################################################################
if command -v mise >/dev/null 2>&1
    # Directly activate mise (simpler and avoids infinite loops)
    mise activate fish | source
    
    # Core operations
    abbr --add mi "mise install" # Install tool version
    abbr --add miu "mise use"    # Use specific version
    abbr --add mil "mise list"   # List installed versions
    abbr --add mig "mise global" # Set global version
    abbr --add milc "mise local" # Set local version
    abbr --add mir "mise run"    # Run command with tool
    abbr --add mie "mise exec"   # Execute with tool version
    
    function mise-setup
        set -l tools \
            python@latest \
            go@latest \
            rust@latest \
            node@lts \
            ruby@latest
        
        for tool in $tools
            mise install $tool
        end
        
        # Set global versions
        mise global python@latest go@latest rust@latest
    end
end

###############################################################################
# direnv (lazy-loaded)
###############################################################################
if command -v direnv >/dev/null 2>&1
    # Create lazy-loaded direnv that only hooks when needed
    function __direnv_activate_if_needed
        if not set -q __direnv_activated
            eval (direnv hook fish)
            set -g __direnv_activated 1
        end
    end
    
    # Wrapper that activates direnv on first use
    function direnv
        __direnv_activate_if_needed
        command direnv $argv
    end
    
    # Auto-activate direnv only when entering directories with .envrc
    function __auto_direnv --on-variable PWD
        if test -f .envrc
            __direnv_activate_if_needed
            direnv allow .
        end
    end
end

###############################################################################
# Go Development
###############################################################################
if command -v go >/dev/null 2>&1
    # Build and Run
    abbr --add gor "go run"               # Run package
    abbr --add gr. "go run ./..."         # Run package
    abbr --add gor. "go run ./..."        # Run package
    abbr --add gorm "go run ./main.go"    #
    abbr --add gobld "go build"           # Build package
    abbr --add gobldr "go build -race"    # Build with race detector
    abbr --add goi "go install"           # Install package
    abbr --add goct "go clean -testcache" # Clean test cache
    
    # Testing
    abbr --add got "go test"                                    # Run tests
    abbr --add gota "go test ./..."                             # Test all packages
    abbr --add gotv "go test -v ./..."                          # Verbose testing
    abbr --add gotc "go test -cover ./..."                      # Test coverage
    abbr --add gotb "go test -bench=."                          # Run benchmarks
    abbr --add gotr "go test -race ./..."                       # Test with race detector
    abbr --add gotcf "go test -coverprofile=coverage.out ./..." # Coverage file
    abbr --add gotw "gotestsum --watch"                         # Watch tests (requires gotestsum)
    
    # Dependencies
    abbr --add gomod "go mod"         # Mod shorthand
    abbr --add gmt "go mod tidy"      # Tidy modules
    abbr --add gomt "go mod tidy"     # Tidy modules
    abbr --add gomv "go mod verify"   # Verify dependencies
    abbr --add gomd "go mod download" # Download dependencies
    abbr --add gomu "go get -u ./..." # Update dependencies
    abbr --add gomw "go mod why"      # Why is module needed
    abbr --add gome "go mod edit"     # Edit go.mod
    abbr --add gomg "go mod graph"    # Module dependency graph
    
    # Tools and Analysis
    abbr --add gof "go fmt ./..."         # Format code
    abbr --add gofi "go fix ./..."        # Fix deprecated syntax
    abbr --add golint "golangci-lint run" # Run linter
    abbr --add gov "go vet ./..."         # Run vet
    abbr --add gogen "go generate ./..."  # Generate code
    
    # Development Tools
    abbr --add gowi "go work init" # Initialize workspace
    abbr --add gowa "go work add"  # Add module to workspace
    abbr --add gows "go work sync" # Sync workspace
    abbr --add gowe "go work edit" # Edit workspace
    
    # Version and Environment
    abbr --add gpath "go env GOPATH" # Show GOPATH
    abbr --add groot "go env GOROOT" # Show GOROOT
    
    # Go format with gofumpt and golines
    function goformat
        gofumpt | golines
    end
end

###############################################################################
# Python Development
###############################################################################
if command -v python3 >/dev/null 2>&1
    # Basic Python commands
    abbr --add py "python3"         # Python shorthand
    abbr --add python "python3"     # Force Python 3
    abbr --add pip "python3 -m pip" # Safe pip usage
    abbr --add pym "python3 -m"     # Run Python modules
    abbr --add pyv "python3 -V"     # Show Python version
    
    # Virtual Environment
    abbr --add venv "python3 -m venv"         # Create venv
    abbr --add va "source .venv/bin/activate.fish" # Activate venv (Fish version)
    abbr --add vd "deactivate"                # Deactivate venv
    abbr --add ve "python3 -m venv .venv"     # Create .venv in current directory
    
    # Package Management
    abbr --add pipi "pip install"                    # Install package
    abbr --add pipie "pip install -e ."              # Install current package in editable mode
    abbr --add pipir "pip install -r"                # Install from requirements
    abbr --add pipu "pip install --upgrade"          # Upgrade package
    abbr --add pipun "pip uninstall"                 # Uninstall package
    abbr --add pipf "pip freeze"                     # Show installed packages
    abbr --add pipfr "pip freeze > requirements.txt" # Generate requirements.txt
    abbr --add pipcheck "pip check"                  # Verify dependencies
    abbr --add pipoutdated "pip list --outdated"     # List outdated packages
    
    # Testing and Quality
    abbr --add pytest "python -m pytest"                     # Run tests
    abbr --add pytestr "python -m pytest --html=report.html" # Generate HTML test report
    abbr --add pytestc "python -m pytest --cov"              # Run tests with coverage
    abbr --add mypy "python -m mypy"                         # Type checking
    abbr --add lint "ruff check"                             # Fast Python linter
    abbr --add black "python -m black"                       # Code formatting
    abbr --add isort "python -m isort"                       # Import sorting
    
    # Development Tools
    abbr --add pydoc "python -m pydoc"                   # Python documentation
    abbr --add pyprof "python -m cProfile -s cumulative" # Basic profiling
    abbr --add pyrepl "python -m IPython"                # Enhanced Python REPL
    abbr --add jupyter "python -m jupyter notebook"      # Start Jupyter notebook
    abbr --add jupyterlab "python -m jupyter lab"        # Start JupyterLab
end

###############################################################################
# Ruby Development (abbrs defined unconditionally - free if unused)
###############################################################################
if command -v ruby >/dev/null 2>&1
    # Basic Ruby commands
    abbr --add rb "ruby"
    abbr --add rbi "irb"
    abbr --add rbv "ruby -v"

    # Gem commands
    abbr --add gemi "gem install"
    abbr --add gemu "gem uninstall"
    abbr --add geml "gem list"
    abbr --add gemo "gem outdated"
    abbr --add gemup "gem update"
    abbr --add gems "gem search -r"
    abbr --add gemc "gem cleanup"

    # Bundle commands
    abbr --add rbb "bundle"
    abbr --add rbbe "bundle exec"
    abbr --add rbbi "bundle install"
    abbr --add rbbu "bundle update"
    abbr --add rbbo "bundle outdated"

    # Rails commands
    abbr --add rbs "rails server"
    abbr --add rbc "rails console"
    abbr --add rbg "rails generate"
    abbr --add rbdbm "rails db:migrate"
    abbr --add rbdbr "rails db:rollback"
end

###############################################################################
# Rust Development
###############################################################################
if command -v cargo >/dev/null 2>&1
    # Basic Cargo commands
    abbr --add cb "cargo build" # Build project
    abbr --add cr "cargo run"   # Run project
    abbr --add ct "cargo test"  # Run tests
    abbr --add cc "cargo check" # Check project
    abbr --add cn "cargo new"   # Create new project
    
    # Development
    abbr --add cw "cargo watch"            # Watch for changes
    abbr --add cwr "cargo watch -x run"    # Watch and run
    abbr --add cwt "cargo watch -x test"   # Watch and test
    abbr --add cbr "cargo build --release" # Build for release
    abbr --add crr "cargo run --release"   # Run release build
    
    # Dependencies
    abbr --add cu "cargo update"   # Update dependencies
    abbr --add ca "cargo add"      # Add dependency
    abbr --add crm "cargo remove"  # Remove dependency
    abbr --add co "cargo outdated" # Show outdated deps
    
    # Tools and Analysis
    abbr --add cf "cargo fmt"           # Format code
    abbr --add cfc "cargo fmt --check"  # Check formatting
    abbr --add cl "cargo clippy"        # Lint code
    abbr --add cla "cargo clippy --all" # Lint all targets
    abbr --add cdo "cargo doc --open"   # Generate and view docs
    abbr --add cexp "cargo expand"      # Expand macros
    
    # Project Maintenance
    abbr --add ccl "cargo clean"         # Clean build artifacts
    abbr --add cv "cargo verify-project" # Verify manifest
    abbr --add ctree "cargo tree"        # Display dependency tree
    abbr --add cbench "cargo bench"      # Run benchmarks
end

###############################################################################
# Node.js Development
###############################################################################
if command -v node >/dev/null 2>&1
    # Node and NPM basics
    abbr --add n "node"                     # Node.js shorthand
    abbr --add nv "node -v"                 # Node.js version
    abbr --add nr "npm run"                 # Run npm script
    abbr --add ni "npm install"             # Install dependencies
    abbr --add nid "npm install --save-dev" # Install dev dependency
    abbr --add nup "npm update"             # Update dependencies
    abbr --add nout "npm outdated"          # Show outdated packages
    abbr --add nrm "npm remove"             # Remove package
    
    # Package management
    abbr --add nci "npm ci"        # Clean install
    abbr --add nau "npm audit"     # Security audit
    abbr --add naf "npm audit fix" # Fix security issues
    abbr --add nl "npm list"       # List packages
    abbr --add nlg "npm list -g"   # List global packages
    
    # Development and Testing
    abbr --add nst "npm test"       # Run tests
    abbr --add nrb "npm run build"  # Build project
    abbr --add nrd "npm run dev"    # Run dev server
    abbr --add nrl "npm run lint"   # Run linter
    abbr --add nrf "npm run format" # Run formatter
end

# pnpm commands (if available)
if command -v pnpm >/dev/null 2>&1
    abbr --add p "pnpm"          # PNPM shorthand
    abbr --add pi "pnpm install" # Install dependencies
    abbr --add pa "pnpm add"     # Add dependency
    abbr --add pad "pnpm add -D" # Add dev dependency
    abbr --add pr "pnpm remove"  # Remove package
    abbr --add pu "pnpm update"  # Update packages
    abbr --add pd "pnpm dev"     # Run dev server
    abbr --add pb "pnpm build"   # Build project
    abbr --add pt "pnpm test"    # Run tests
    abbr --add pl "pnpm lint"    # Run linter
end

