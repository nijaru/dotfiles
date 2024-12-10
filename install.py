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

    # Git configs
    ("git/.gitconfig", ".gitconfig", 0o644),
    ("git/.gitignore", ".gitignore", 0o644),

    # SSH config
    ("ssh/config", ".ssh/config", 0o600),

    # App configs
    ("config/ghostty/config", ".config/ghostty/config", 0o644),
    ("config/zed/settings.json", ".config/zed/settings.json", 0o644),
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
    def __init__(self, *, dry_run: bool = False, force: bool = False):
        self.home = Path.home()
        self.dotfiles = self.home / "github" / "dotfiles"
        self.backup_dir = self.home / f".dotfiles_backups/backup_{datetime.now():%Y%m%d_%H%M%S}"
        self.dry_run = dry_run
        self.force = force
        self.system = platform.system()
        self.log = self._setup_logger()

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
            self.log.error("Zsh is not installed")
            return False

        # Check for zsh4humans
        z4h_path = self.home / ".cache/zsh4humans/v5/z4h.zsh"
        if not z4h_path.exists():
            self.log.error("Zsh4humans is not installed")
            self.log.info("Install with: sh -c \"$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)\"")
            return False

        return True

    def backup_file(self, path: Path) -> None:
        """Create backup of existing file"""
        if not path.exists() and not path.is_symlink():
            return

        try:
            self.backup_dir.mkdir(parents=True, exist_ok=True)
            backup_path = self.backup_dir / path.name

            if backup_path.exists():
                timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                backup_path = self.backup_dir / f"{path.name}.{timestamp}"

            shutil.copy2(path, backup_path)
            self.log.info(f"Backed up: {path} → {backup_path}")
        except Exception as e:
            self.log.error(f"Failed to backup {path}: {e}")
            raise

    def create_symlink(self, config: Config) -> bool:
        """Create symbolic link with proper permissions"""
        if self.dry_run:
            self.log.info(f"[Dry Run] Would link: {config.target} → {config.source}")
            return True

        try:
            if config.target.exists() or config.target.is_symlink():
                if not self.force:
                    self.log.warning(f"Skipping existing file: {config.target}")
                    return False
                self.backup_file(config.target)
                config.target.unlink()

            config.target.parent.mkdir(parents=True, exist_ok=True)
            config.target.symlink_to(config.source)
            config.target.chmod(config.mode)
            self.log.info(f"Linked: {config.target} → {config.source}")
            return True
        except Exception as e:
            self.log.error(f"Failed to link {config.target}: {e}")
            return False

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

        success = True
        for config in configs:
            if not self.create_symlink(config):
                success = False

        return success

def main():
    parser = argparse.ArgumentParser(description="Install dotfiles")
    parser.add_argument("--dry-run", action="store_true", help="Show what would be done")
    parser.add_argument("--force", action="store_true", help="Force overwrite existing files")
    args = parser.parse_args()

    try:
        installer = DotfilesInstaller(dry_run=args.dry_run, force=args.force)
        if installer.install():
            installer.log.info("\n✨ Dotfiles installation complete!")
            if not args.dry_run:
                installer.log.info(f"Backups stored in: {installer.backup_dir}")
            installer.log.info("Please restart your shell for changes to take effect.")
            return 0
        return 1
    except Exception as e:
        print(f"Installation failed: {e}", file=sys.stderr)
        return 1

if __name__ == "__main__":
    sys.exit(main())
