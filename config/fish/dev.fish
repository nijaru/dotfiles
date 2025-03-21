#!/usr/bin/env fish
# Development environment configuration for Fish shell

###############################################################################
# General Development
###############################################################################
# modular / mojo / magic
if command -v magic >/dev/null 2>&1
    abbr --add m "magic"
end

###############################################################################
# mise
###############################################################################
if command -v mise >/dev/null 2>&1
    # Initialize mise (Fish has a better way to do this)
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
# Ruby Development
###############################################################################
if command -v ruby >/dev/null 2>&1
    # Helper function for gem checking
    function gem_installed
        # Fish has issues with passing regex to external commands in some cases
        # So we'll just pass the name and let gem handle it
        gem list -i $argv[1] >/dev/null 2>&1
    end
    
    # Basic Ruby commands
    abbr --add rb "ruby"     # Ruby shorthand
    abbr --add rbi "irb"     # Interactive Ruby
    abbr --add rbv "ruby -v" # Ruby version
    
    # Gem commands - only if gem command exists
    if command -v gem >/dev/null 2>&1
        abbr --add gemi "gem install"     # Install a gem
        abbr --add gemu "gem uninstall"   # Uninstall a gem
        abbr --add geml "gem list"        # List installed gems
        abbr --add gemr "gem rdoc"        # Generate RDoc
        abbr --add gemt "gem test"        # Run tests for gem
        abbr --add gemo "gem outdated"    # Show outdated gems
        abbr --add gemup "gem update"     # Update all gems
        abbr --add gems "gem search -r"   # Search for gems
        abbr --add gemp "gem pristine"    # Reset gems to pristine condition
        abbr --add gemb "gem build"       # Build gem from gemspec
        abbr --add gemc "gem cleanup"     # Clean old gem versions
        abbr --add gemv "gem env version" # Show gem version
        abbr --add gemh "gem help"        # Show gem help
    end
    
    # Bundle commands - only if bundler is installed
    if gem_installed bundler
        abbr --add rbb "bundle"           # Bundle shorthand
        abbr --add rbbe "bundle exec"     # Bundle exec
        abbr --add rbbi "bundle install"  # Install dependencies
        abbr --add rbbu "bundle update"   # Update dependencies
        abbr --add rbbo "bundle outdated" # Show outdated gems
        abbr --add rbbc "bundle clean"    # Clean old gems
        abbr --add rbbp "bundle package"  # Package gems
        abbr --add rbbck "bundle check"   # Verify dependencies
        abbr --add rbbl "bundle list"     # List gems
        abbr --add rbbop "bundle open"    # Open gem source
        abbr --add rbbin "bundle info"    # Show gem info
    end
    
    # Rails commands - only if rails is installed
    if gem_installed rails
        abbr --add rbs "rails server"                # Start Rails server
        abbr --add rbc "rails console"               # Rails console
        abbr --add rbg "rails generate"              # Rails generate
        abbr --add rbgm "rails generate migration"   # Generate migration
        abbr --add rbr "rails routes"                # Show routes
        abbr --add rbdb "rails db"                   # Database tasks
        abbr --add rbdbm "rails db:migrate"          # Run migrations
        abbr --add rbdbs "rails db:seed"             # Seed database
        abbr --add rbdbc "rails db:create"           # Create database
        abbr --add rbdbd "rails db:drop"             # Drop database
        abbr --add rbdbr "rails db:rollback"         # Rollback migration
        abbr --add rbdbrb "rails db:rollback STEP=1" # Rollback one step
        
        # Testing
        abbr --add rt "rails test"         # Run tests
        abbr --add rts "rails test:system" # Run system tests
    end
    
    # RSpec commands - only if rspec is installed
    if gem_installed rspec
        abbr --add spec "rspec"                       # Run RSpec tests
        abbr --add rsf "rspec --format documentation" # Formatted RSpec output
        abbr --add rsp "rspec --profile"              # Show slow examples
        abbr --add rsw "rspec --profile --warnings"   # Show warnings
    end
    
    # Development Tools - only if the respective tools are installed
    if gem_installed rubocop
        abbr --add rubocop "bundle exec rubocop"  # Ruby linter
        abbr --add rubo "bundle exec rubocop -a"  # Auto-correct Ruby style
        abbr --add ruboa "bundle exec rubocop -A" # Auto-correct aggressive
    end
    
    if gem_installed solargraph
        abbr --add solargraph "bundle exec solargraph" # Ruby language server
    end
    
    if gem_installed fasterer
        abbr --add fasterer "bundle exec fasterer" # Speed suggestions
    end
    
    if gem_installed brakeman
        abbr --add brakeman "bundle exec brakeman" # Security scanner
    end
    
    if command -v pry >/dev/null 2>&1
        abbr --add rbpry "pry -r ./config/environment" # Rails console with Pry
    end
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