#!/usr/bin/env zsh
# Development environment configuration
# Language-specific settings and tools

###############################################################################
# mise (formerly rtx) Package Manager
###############################################################################
if command_exists mise; then
    # Initialize mise
    eval "$(mise activate zsh)"

    # Core operations
    alias mi="mise install" # Install tool version
    alias miu="mise use"    # Use specific version
    alias mil="mise list"   # List installed versions
    alias mig="mise global" # Set global version
    alias milc="mise local" # Set local version
    alias mir="mise run"    # Run command with tool
    alias mie="mise exec"   # Execute with tool version

    function mise-setup() {
        local tools=(
            python@latest
            go@latest
            rust@latest
            node@lts
            ruby@latest
        )

        for tool in "${tools[@]}"; do
            mise install "$tool"
        done

        # Set global versions
        mise global python@latest go@latest rust@latest
    }
fi

###############################################################################
# Go Development
###############################################################################
if command_exists go; then
    # Build and Run
    alias gr="go run"               # Run package
    alias grun="go run ."           # Run current package
    alias gbld="go build"           # Build package
    alias gbldr="go build -race"    # Build with race detector
    alias gi="go install"           # Install package
    alias gct="go clean -testcache" # Clean test cache

    # Testing
    alias gt="go test"                                    # Run tests
    alias gta="go test ./..."                             # Test all packages
    alias gtv="go test -v ./..."                          # Verbose testing
    alias gtc="go test -cover ./..."                      # Test coverage
    alias gtb="go test -bench=."                          # Run benchmarks
    alias gtr="go test -race ./..."                       # Test with race detector
    alias gtcf="go test -coverprofile=coverage.out ./..." # Coverage file
    alias gtw="gotestsum --watch"                         # Watch tests (requires gotestsum)

    # Dependencies
    alias gmod="go mod"         # Mod shorthand
    alias gmt="go mod tidy"     # Tidy modules
    alias gmv="go mod verify"   # Verify dependencies
    alias gmd="go mod download" # Download dependencies
    alias gmu="go get -u ./..." # Update dependencies
    alias gmw="go mod why"      # Why is module needed
    alias gme="go mod edit"     # Edit go.mod
    alias gmg="go mod graph"    # Module dependency graph

    # Tools and Analysis
    # alias gf="go fmt ./..."         # Format code
    alias gfi="go fix ./..."        # Fix deprecated syntax
    alias glint="golangci-lint run" # Run linter
    alias gv="go vet ./..."         # Run vet
    alias ggen="go generate ./..."  # Generate code

    # Development Tools
    alias gwi="go work init" # Initialize workspace
    alias gwa="go work add"  # Add module to workspace
    alias gws="go work sync" # Sync workspace
    alias gwe="go work edit" # Edit workspace

    # Version and Environment
    alias gver="go version"     # Show Go version
    alias genv="go env"         # Show Go environment
    alias gpath="go env GOPATH" # Show GOPATH
    alias groot="go env GOROOT" # Show GOROOT
fi

###############################################################################
# Python Development
###############################################################################
if command_exists python3; then
    # Basic Python commands
    alias py="python3"         # Python shorthand
    alias python="python3"     # Force Python 3
    alias pip="python3 -m pip" # Safe pip usage
    alias pym="python3 -m"     # Run Python modules
    alias pyv="python3 -V"     # Show Python version

    # Virtual Environment
    alias venv="python3 -m venv"         # Create venv
    alias va="source .venv/bin/activate" # Activate venv
    alias vd="deactivate"                # Deactivate venv
    alias ve="python3 -m venv .venv"     # Create .venv in current directory

    # Package Management
    alias pipi="pip install"                    # Install package
    alias pipie="pip install -e ."              # Install current package in editable mode
    alias pipir="pip install -r"                # Install from requirements
    alias pipu="pip install --upgrade"          # Upgrade package
    alias pipun="pip uninstall"                 # Uninstall package
    alias pipf="pip freeze"                     # Show installed packages
    alias pipfr="pip freeze > requirements.txt" # Generate requirements.txt
    alias pipcheck="pip check"                  # Verify dependencies
    alias pipoutdated="pip list --outdated"     # List outdated packages

    # Testing and Quality
    alias pytest="python -m pytest"                     # Run tests
    alias pytestr="python -m pytest --html=report.html" # Generate HTML test report
    alias pytestc="python -m pytest --cov"              # Run tests with coverage
    alias mypy="python -m mypy"                         # Type checking
    alias lint="ruff check"                             # Fast Python linter
    alias black="python -m black"                       # Code formatting
    alias isort="python -m isort"                       # Import sorting

    # Development Tools
    alias pydoc="python -m pydoc"                   # Python documentation
    alias pyprof="python -m cProfile -s cumulative" # Basic profiling
    alias pyrepl="python -m IPython"                # Enhanced Python REPL
    alias jupyter="python -m jupyter notebook"      # Start Jupyter notebook
    alias jupyterlab="python -m jupyter lab"        # Start JupyterLab
fi

###############################################################################
# Ruby Development
###############################################################################
if command_exists ruby; then
    # Helper function for gem checking
    function gem_installed() {
        gem list "^$1$" -i >/dev/null 2>&1
    }

    # Basic Ruby commands
    alias rb="ruby"     # Ruby shorthand
    alias rbi="irb"     # Interactive Ruby
    alias rbv="ruby -v" # Ruby version

    # Gem commands - only if gem command exists
    if command_exists gem; then
        alias gemi="gem install"     # Install a gem
        alias gemu="gem uninstall"   # Uninstall a gem
        alias geml="gem list"        # List installed gems
        alias gemr="gem rdoc"        # Generate RDoc
        alias gemt="gem test"        # Run tests for gem
        alias gemo="gem outdated"    # Show outdated gems
        alias gemup="gem update"     # Update all gems
        alias gems="gem search -r"   # Search for gems
        alias gemp="gem pristine"    # Reset gems to pristine condition
        alias gemb="gem build"       # Build gem from gemspec
        alias gemc="gem cleanup"     # Clean old gem versions
        alias gemv="gem env version" # Show gem version
        alias gemh="gem help"        # Show gem help
    fi

    # Bundle commands - only if bundler is installed
    if gem_installed bundler; then
        alias rbb="bundle"           # Bundle shorthand
        alias rbbe="bundle exec"     # Bundle exec
        alias rbbi="bundle install"  # Install dependencies
        alias rbbu="bundle update"   # Update dependencies
        alias rbbo="bundle outdated" # Show outdated gems
        alias rbbc="bundle clean"    # Clean old gems
        alias rbbp="bundle package"  # Package gems
        alias rbbck="bundle check"   # Verify dependencies
        alias rbbl="bundle list"     # List gems
        alias rbbop="bundle open"    # Open gem source
        alias rbbin="bundle info"    # Show gem info
    fi

    # Rails commands - only if rails is installed
    if gem_installed rails; then
        alias rs="rails server"                # Start Rails server
        alias rc="rails console"               # Rails console
        alias rg="rails generate"              # Rails generate
        alias rgm="rails generate migration"   # Generate migration
        alias rr="rails routes"                # Show routes
        alias rdb="rails db"                   # Database tasks
        alias rdbm="rails db:migrate"          # Run migrations
        alias rdbs="rails db:seed"             # Seed database
        alias rdbc="rails db:create"           # Create database
        alias rdbd="rails db:drop"             # Drop database
        alias rdbr="rails db:rollback"         # Rollback migration
        alias rdbrb="rails db:rollback STEP=1" # Rollback one step

        # Testing
        alias rt="rails test"         # Run tests
        alias rts="rails test:system" # Run system tests
    fi

    # RSpec commands - only if rspec is installed
    if gem_installed rspec; then
        alias spec="rspec"                       # Run RSpec tests
        alias rsf="rspec --format documentation" # Formatted RSpec output
        alias rsp="rspec --profile"              # Show slow examples
        alias rsw="rspec --profile --warnings"   # Show warnings
    fi

    # Development Tools - only if the respective tools are installed
    if gem_installed rubocop; then
        alias rubocop="bundle exec rubocop"  # Ruby linter
        alias rubo="bundle exec rubocop -a"  # Auto-correct Ruby style
        alias ruboa="bundle exec rubocop -A" # Auto-correct aggressive
    fi

    if gem_installed solargraph; then
        alias solargraph="bundle exec solargraph" # Ruby language server
    fi

    if gem_installed fasterer; then
        alias fasterer="bundle exec fasterer" # Speed suggestions
    fi

    if gem_installed brakeman; then
        alias brakeman="bundle exec brakeman" # Security scanner
    fi

    if command_exists pry; then
        alias rbpry="pry -r ./config/environment" # Rails console with Pry
    fi
fi

###############################################################################
# Rust Development
###############################################################################
if command_exists cargo; then
    # Basic Cargo commands
    alias cb="cargo build" # Build project
    alias cr="cargo run"   # Run project
    alias ct="cargo test"  # Run tests
    alias cc="cargo check" # Check project
    alias cn="cargo new"   # Create new project

    # Development
    alias cw="cargo watch"            # Watch for changes
    alias cwr="cargo watch -x run"    # Watch and run
    alias cwt="cargo watch -x test"   # Watch and test
    alias cbr="cargo build --release" # Build for release
    alias crr="cargo run --release"   # Run release build

    # Dependencies
    alias cu="cargo update"   # Update dependencies
    alias ca="cargo add"      # Add dependency
    alias crm="cargo remove"  # Remove dependency
    alias co="cargo outdated" # Show outdated deps

    # Tools and Analysis
    alias cf="cargo fmt"           # Format code
    alias cfc="cargo fmt --check"  # Check formatting
    alias cl="cargo clippy"        # Lint code
    alias cla="cargo clippy --all" # Lint all targets
    alias cdo="cargo doc --open"   # Generate and view docs
    alias cexp="cargo expand"      # Expand macros

    # Project Maintenance
    alias ccl="cargo clean"         # Clean build artifacts
    alias cv="cargo verify-project" # Verify manifest
    alias ct="cargo tree"           # Display dependency tree
    alias cbench="cargo bench"      # Run benchmarks
fi

###############################################################################
# Node.js Development
###############################################################################
if command_exists node; then
    # Node and NPM basics
    alias n="node"                     # Node.js shorthand
    alias nv="node -v"                 # Node.js version
    alias nr="npm run"                 # Run npm script
    alias ni="npm install"             # Install dependencies
    alias nid="npm install --save-dev" # Install dev dependency
    alias nup="npm update"             # Update dependencies
    alias nout="npm outdated"          # Show outdated packages
    alias nrm="npm remove"             # Remove package

    # Package management
    alias nci="npm ci"        # Clean install
    alias nau="npm audit"     # Security audit
    alias naf="npm audit fix" # Fix security issues
    alias nl="npm list"       # List packages
    alias nlg="npm list -g"   # List global packages

    # Development and Testing
    alias nst="npm test"       # Run tests
    alias nrb="npm run build"  # Build project
    alias nrd="npm run dev"    # Run dev server
    alias nrl="npm run lint"   # Run linter
    alias nrf="npm run format" # Run formatter
fi

# pnpm commands (if available)
if command_exists pnpm; then
    alias p="pnpm"          # PNPM shorthand
    alias pi="pnpm install" # Install dependencies
    alias pa="pnpm add"     # Add dependency
    alias pad="pnpm add -D" # Add dev dependency
    alias pr="pnpm remove"  # Remove package
    alias pu="pnpm update"  # Update packages
    alias pd="pnpm dev"     # Run dev server
    alias pb="pnpm build"   # Build project
    alias pt="pnpm test"    # Run tests
    alias pl="pnpm lint"    # Run linter
fi
