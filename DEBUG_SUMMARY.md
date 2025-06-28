# SSH Double Prompt Debug Summary

## Current Status
- **Platform**: Fedora 42 (Linux) accessed via SSH from macOS
- **Terminal**: Ghostty on macOS
- **Shell**: Fish (set as default on Fedora)
- **Issue**: Double prompts in fish over SSH (single prompts work with `fish --no-config`)

## Key Fixes Applied
1. **TERM Variable**: Fixed `'xterm-ghostty': unknown terminal type` error
   - Solution: `export TERM=xterm-256color` (fixes bash clear/Ctrl-L)
   - Need permanent fix in dotfiles for SSH sessions

2. **Mise/npm**: Fixed mise activation in fish completions
   - Added `mise activate fish | source` to completions.fish
   - npm and Node.js tools now work properly

3. **SSH Config**: Made UseKeychain macOS-specific with templating
   - Prevents SSH errors on Linux systems

4. **Platform Files**: Recovered missing fish configs
   - darwin.fish (brew abbreviations)
   - linux.fish (systemctl/dnf abbreviations) 
   - dev.fish, docker.fish, editor.fish

5. **dnf.conf**: Created Linux-specific optimized config
   - Fast internet settings (50 parallel downloads, no deltarpm)
   - defaultyes=True behavior

## Current Problem: Double Prompts
- **Root Cause**: Fish configuration issue (NOT transient prompts)
- **Evidence**: 
  - Single prompt with `fish --no-config`
  - `set -g tide_prompt_transient_enabled false` doesn't fix it
  - Issue persists after SSH transient prompt detection fix

## Fish Config Structure
```
~/.config/fish/
├── config.fish (loads platform-specific files)
├── darwin.fish (macOS - brew abbreviations)
├── linux.fish (Linux - systemctl/dnf abbreviations)
├── dev.fish, docker.fish, editor.fish
└── conf.d/
    ├── completions.fish (mise activation + SSH transient detection)
    └── other config files
```

## SSH Transient Prompt Detection (IMPLEMENTED)
```fish
# In config.fish - clears universal vars, sets session vars
if status is-interactive
    set -e tide_prompt_transient_enabled 2>/dev/null
    if set -q SSH_CLIENT; or set -q SSH_TTY
        set -g tide_prompt_transient_enabled false
    else
        set -g tide_prompt_transient_enabled true
    end
end
```

## Debug Commands for Double Prompt Issue
```bash
# Check prompt functions
functions | grep prompt
type fish_prompt

# Check tide functions
functions | grep tide | head -10

# Isolate config issue
cd ~/.config/fish
mv config.fish config.fish.bak
fish  # Test if single prompt
```

## PATH Issues Found
- Fish PATH contained macOS paths on Linux: `/opt/homebrew/bin`, `/Users/nick/...`
- Suggests platform detection or path configuration problems
- chezmoi located at `~/bin/chezmoi` but not in fish PATH initially

## Required Permanent Fixes
1. **TERM variable for SSH sessions**:
   ```fish
   if set -q SSH_CLIENT; or set -q SSH_TTY
       set -gx TERM xterm-256color
   end
   ```

2. **PATH correction**: Ensure Linux systems don't get macOS paths

3. **Double prompt root cause**: Likely tide initialization or config file loading issue

## Installation Status
- Fish: Default shell ✓
- mise: Installed, needs `mise install usage` for completions
- chezmoi: At `~/bin/chezmoi`
- All dotfiles applied via `~/bin/chezmoi apply --force`

## Next Steps
1. Debug which config file causes double prompts (rename test)
2. Add TERM fix to dotfiles permanently  
3. Fix PATH platform detection issue
4. Test SSH reconnection behavior after fixes