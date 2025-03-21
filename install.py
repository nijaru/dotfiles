#!/usr/bin/env python3

import argparse
import logging
import platform
import shutil
import sys
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Tuple


# Configuration type definition
@dataclass(frozen=True)
class Config:
    """Configuration file definition"""
    source: Path
    target: Path
    mode: int

# Define all configurations to install
# (source_path, target_path, file_mode)
CORE_CONFIGS: List[Tuple[str, str, int]] = [
    # Shell configs
    ("shell/.zshenv", ".zshenv", 0o644),
    ("shell/.zshrc", ".zshrc", 0o644),
    ("shell/.env.zsh", ".env.zsh", 0o644),
    ("shell/.aliases.zsh", ".aliases.zsh", 0o644),
    ("shell/.functions.zsh", ".functions.zsh", 0o644),
    ("shell/.git.zsh", ".git.zsh", 0o644),
    ("shell/.dev.zsh", ".dev.zsh", 0o644),
    ("shell/.docker.zsh", ".docker.zsh", 0o644),
    ("shell/.p10k.zsh", ".p10k.zsh", 0o644),
    
    # Fish shell configs
    ("config/fish/config.fish", ".config/fish/config.fish", 0o644),
    ("config/fish/env.fish", ".config/fish/env.fish", 0o644),
    ("config/fish/git.fish", ".config/fish/git.fish", 0o644),
    ("config/fish/dev.fish", ".config/fish/dev.fish", 0o644),
    ("config/fish/docker.fish", ".config/fish/docker.fish", 0o644),
    ("config/fish/editor.fish", ".config/fish/editor.fish", 0o644),
    ("config/fish/linux.fish", ".config/fish/linux.fish", 0o644),
    ("config/fish/darwin.fish", ".config/fish/darwin.fish", 0o644),
    ("config/fish/fish_plugins", ".config/fish/fish_plugins", 0o644),
    ("config/fish/fish_variables", ".config/fish/fish_variables", 0o644),
    ("config/fish/completions/tide.fish", ".config/fish/completions/tide.fish", 0o644),

    # Git configs
    ("git/.gitconfig", ".gitconfig", 0o644),
    ("git/.gitignore", ".gitignore", 0o644),

    # SSH config
    ("ssh/config", ".ssh/config", 0o600),

    # App configs
    ("config/ghostty/config", ".config/ghostty/config", 0o644),
    ("config/zed/settings.json", ".config/zed/settings.json", 0o644),
    ("config/starship.toml", ".config/starship.toml", 0o644),
]

# OS-specific configurations
OS_CONFIGS: Dict[str, List[Tuple[str, str, int]]] = {
    "Darwin": [
        ("shell/.darwin.zsh", ".darwin.zsh", 0o644),
        ("gnupg/gpg-agent.conf", ".gnupg/gpg-agent.conf", 0o600),
    ],
    "Linux": [
        ("shell/.linux.zsh", ".linux.zsh", 0o644),
    ],
}

class DotfilesInstaller:
    def __init__(self, *, dry_run: bool = False, force: bool = False, clean: bool = False):
        self.home = Path.home()
        self.dotfiles = self.home / "github" / "dotfiles"
        self.backup_dir = self.home / f".dotfiles_backups/backup_{datetime.now():%Y%m%d_%H%M%S}"
        self.dry_run = dry_run
        self.force = force
        self.clean = clean
        self.system = platform.system()
        self.log = self._setup_logger()
        self.installed_paths = set()

    def _setup_logger(self) -> logging.Logger:
        """Configure logging with colors"""
        class ColorFormatter(logging.Formatter):
            COLORS = {
                "INFO": "\033[92m",     # Green
                "WARNING": "\033[93m",   # Yellow
                "ERROR": "\033[91m",     # Red
                "RESET": "\033[0m"
            }

            def format(self, record):
                color = self.COLORS.get(record.levelname, self.COLORS["RESET"])
                return f"{color}{record.getMessage()}{self.COLORS['RESET']}"

        logger = logging.getLogger("dotfiles")
        handler = logging.StreamHandler()
        handler.setFormatter(ColorFormatter())
        logger.addHandler(handler)
        logger.setLevel(logging.INFO)
        return logger

    def verify_dependencies(self) -> bool:
        """Verify required dependencies are installed"""
        # Check for zsh
        if not shutil.which("zsh"):
            self.log.warning("Zsh is not installed (needed for ZSH configs)")
        
        # Check for fish
        if not shutil.which("fish"):
            self.log.warning("Fish is not installed (needed for Fish configs)")
        
        # Check for Starship
        if not shutil.which("starship"):
            self.log.warning("Starship is not installed. For terminal prompt, install with: brew install starship")
        
        return True

    def backup_file(self, path: Path) -> None:
        """Create backup of existing file"""
        if not path.exists() and not path.is_symlink():
            return

        try:
            self.backup_dir.mkdir(parents=True, exist_ok=True)
            
            # Create relative path structure for backup
            rel_path = path.relative_to(self.home)
            backup_path = self.backup_dir / rel_path
            
            # Ensure parent directory exists in backup location
            backup_path.parent.mkdir(parents=True, exist_ok=True)

            if backup_path.exists():
                timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                backup_path = backup_path.parent / f"{backup_path.name}.{timestamp}"

            # For symlinks, we want to copy the link itself, not its target
            if path.is_symlink():
                # Get the target of the symlink
                target = path.readlink()
                # Create a new symlink in the backup location pointing to the same target
                if backup_path.exists():
                    backup_path.unlink()
                backup_path.symlink_to(target)
                self.log.info(f"Backed up symlink: {path} → {backup_path}")
            else:
                # For regular files, copy the file content
                shutil.copy2(path, backup_path)
                self.log.info(f"Backed up: {path} → {backup_path}")
        except Exception as e:
            self.log.error(f"Failed to backup {path}: {e}")
            # Log the error but continue instead of raising an exception
            # This allows the installation to continue even if a backup fails
            # raise

    def create_symlink(self, config: Config) -> bool:
        """Create symbolic link with proper permissions"""
        if self.dry_run:
            self.log.info(f"[Dry Run] Would link: {config.target} → {config.source}")
            # Track this path for cleanup
            self.installed_paths.add(config.target)
            return True

        try:
            # Ensure parent directory exists
            config.target.parent.mkdir(parents=True, exist_ok=True)
            
            if config.target.exists() or config.target.is_symlink():
                if not self.force:
                    self.log.warning(f"Skipping existing file: {config.target}")
                    # Still track this path for cleanup purposes
                    self.installed_paths.add(config.target)
                    return False
                self.backup_file(config.target)
                config.target.unlink()

            config.target.symlink_to(config.source)
            config.target.chmod(config.mode)
            self.log.info(f"Linked: {config.target} → {config.source}")
            
            # Track this path for cleanup
            self.installed_paths.add(config.target)
            return True
        except Exception as e:
            self.log.error(f"Failed to link {config.target}: {e}")
            return False

    def clean_stale_symlinks(self) -> bool:
        """Remove stale symlinks that point to non-existent files"""
        # Check common directories for stale symlinks
        directories_to_check = [
            self.home / ".config" / "fish" / "functions",
            self.home / ".config" / "fish" / "conf.d",
            self.home / ".config" / "fish",
        ]
        
        # Also check all subdirectories of fish/functions
        fish_functions_dir = self.home / ".config" / "fish" / "functions"
        if fish_functions_dir.exists() and fish_functions_dir.is_dir():
            for subdir in fish_functions_dir.iterdir():
                if subdir.is_dir():
                    directories_to_check.append(subdir)
        
        success = True
        removed_count = 0
        
        for directory in directories_to_check:
            if not directory.exists() or not directory.is_dir():
                continue
                
            for file_path in directory.iterdir():
                # Skip if not a symlink or if it's in our installed paths
                if not file_path.is_symlink() or file_path in self.installed_paths:
                    continue
                
                # Skip if we're trying to backup but the file doesn't exist
                if not file_path.exists() and not file_path.is_symlink():
                    continue
                    
                # Get the target of the symlink
                try:
                    target = file_path.resolve(strict=False)
                    # Check if the target exists and is within our dotfiles dir
                    if not target.exists() and str(self.dotfiles) in str(target):
                        if self.dry_run:
                            self.log.info(f"[Dry Run] Would remove stale symlink: {file_path} → {target}")
                        else:
                            # Only attempt backup if the file actually exists
                            if file_path.exists() or file_path.is_symlink():
                                try:
                                    self.backup_file(file_path)
                                except Exception as e:
                                    self.log.warning(f"Could not backup {file_path}: {e}")
                            
                            # Try to remove the symlink
                            try:
                                file_path.unlink()
                                self.log.info(f"Removed stale symlink: {file_path} → {target}")
                                removed_count += 1
                            except Exception as e:
                                self.log.error(f"Failed to remove symlink {file_path}: {e}")
                                success = False
                except Exception as e:
                    self.log.error(f"Failed to check symlink {file_path}: {e}")
                    success = False
        
        if removed_count > 0 or self.dry_run:
            self.log.info(f"{'Would remove' if self.dry_run else 'Removed'} {removed_count} stale symlinks")
            
        return success

    def install(self) -> bool:
        """Install all configuration files"""
        if not self.verify_dependencies():
            return False

        configs = []

        # Add core configs
        configs.extend(Config(
            source=self.dotfiles / src,
            target=self.home / target,
            mode=mode
        ) for src, target, mode in CORE_CONFIGS)

        # Add OS-specific configs
        if self.system in OS_CONFIGS:
            configs.extend(Config(
                source=self.dotfiles / src,
                target=self.home / target,
                mode=mode
            ) for src, target, mode in OS_CONFIGS[self.system])
            
        # Add all Fish function files dynamically, including subdirectories
        fish_functions_dir = self.dotfiles / "config" / "fish" / "functions"
        if fish_functions_dir.exists() and fish_functions_dir.is_dir():
            # First, add top-level function files
            function_files = list(fish_functions_dir.glob("*.fish"))
            if function_files:
                self.log.info(f"Adding {len(function_files)} top-level Fish functions from {fish_functions_dir}")
                configs.extend(Config(
                    source=func_file,
                    target=self.home / ".config" / "fish" / "functions" / func_file.name,
                    mode=0o644
                ) for func_file in function_files)
                
            # Then add files from subdirectories
            for subdir in fish_functions_dir.iterdir():
                if subdir.is_dir() and not subdir.name.startswith('.'):
                    sub_function_files = list(subdir.glob("*.fish"))
                    if sub_function_files:
                        # Create the corresponding subdirectory in the target
                        target_subdir = self.home / ".config" / "fish" / "functions" / subdir.name
                        if not self.dry_run:
                            target_subdir.mkdir(parents=True, exist_ok=True)
                            
                        self.log.info(f"Adding {len(sub_function_files)} Fish functions from {subdir}")
                        configs.extend(Config(
                            source=func_file,
                            target=self.home / ".config" / "fish" / "functions" / subdir.name / func_file.name,
                            mode=0o644
                        ) for func_file in sub_function_files)
                
        # Add all Fish conf.d files dynamically
        fish_confd_dir = self.dotfiles / "config" / "fish" / "conf.d"
        if fish_confd_dir.exists() and fish_confd_dir.is_dir():
            confd_files = list(fish_confd_dir.glob("*.fish"))
            if confd_files:
                self.log.info(f"Adding {len(confd_files)} Fish conf.d files from {fish_confd_dir}")
                configs.extend(Config(
                    source=conf_file,
                    target=self.home / ".config" / "fish" / "conf.d" / conf_file.name,
                    mode=0o644
                ) for conf_file in confd_files)

        success = True
        for config in configs:
            if not self.create_symlink(config):
                success = False
                
        # Clean up stale symlinks if requested
        if self.clean:
            if not self.clean_stale_symlinks():
                success = False

        return success

def main():
    parser = argparse.ArgumentParser(description="Install dotfiles")
    parser.add_argument("--dry-run", action="store_true", help="Show what would be done")
    parser.add_argument("--force", action="store_true", help="Force overwrite existing files")
    parser.add_argument("--clean", action="store_true", help="Remove stale symlinks without source files")
    args = parser.parse_args()

    try:
        installer = DotfilesInstaller(dry_run=args.dry_run, force=args.force, clean=args.clean)
        if installer.install():
            installer.log.info("\n✨ Dotfiles installation complete!")
            if not args.dry_run and installer.backup_dir.exists():
                installer.log.info(f"Backups stored in: {installer.backup_dir}")
            installer.log.info("Please restart your shell for changes to take effect.")
            return 0
        return 1
    except Exception as e:
        print(f"Installation failed: {e}", file=sys.stderr)
        return 1

if __name__ == "__main__":
    sys.exit(main())
