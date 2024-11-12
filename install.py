#!/usr/bin/env python3

from __future__ import annotations

import argparse
import asyncio
import logging
import platform
import shutil
import sys
from dataclasses import dataclass
from datetime import datetime
from enum import Enum
from pathlib import Path


class DotfilesError(Exception):
    """Base exception for dotfiles installer"""


class DependencyError(DotfilesError):
    """Missing dependency error"""


class InstallationError(DotfilesError):
    """Installation failure error"""


@dataclass(frozen=True)
class Config:
    """Configuration file definition"""

    source: Path
    target: Path
    mode: int
    required: bool = False


class ConfigType(Enum):
    """Types of configuration files"""

    SHELL = "shell"
    GIT = "git"
    SECURITY = "security"
    APP = "app"


class DotfilesInstaller:
    def __init__(self, *, dry_run: bool = False, force: bool = False) -> None:
        self.home: Path = Path.home()
        self.dotfiles: Path = self.home / "github" / "dotfiles"
        self.config: Path = self.home / ".config"
        self.backup_dir: Path = (
            self.home / ".dotfiles_backups" / f"backup_{datetime.now():%Y%m%d_%H%M%S}"
        )
        self.system: str = platform.system()
        self.dry_run: bool = dry_run
        self.force: bool = force
        self.log = self._setup_logger()

    def _setup_logger(self) -> logging.Logger:
        """Configure colored logging"""

        class ColorFormatter(logging.Formatter):
            COLORS = {
                "INFO": "\033[92m",  # Green
                "WARNING": "\033[93m",  # Yellow
                "ERROR": "\033[91m",  # Red
                "RESET": "\033[0m",
            }

            def format(self, record: logging.LogRecord) -> str:
                color = self.COLORS.get(record.levelname, self.COLORS["RESET"])
                record.msg = f"{color}{record.msg}{self.COLORS['RESET']}"
                return super().format(record)

        logger = logging.getLogger("dotfiles")
        handler = logging.StreamHandler()
        handler.setFormatter(ColorFormatter("%(message)s"))
        logger.addHandler(handler)
        logger.setLevel(logging.INFO)
        return logger

    async def __aenter__(self) -> DotfilesInstaller:
        """Async context manager entry"""
        await self.setup_directories()
        return self

    async def __aexit__(self, exc_type, exc_val, exc_tb) -> None:
        """Async context manager exit"""
        if exc_type is not None:
            self.log.error(f"Installation failed: {exc_val}")

    def get_configs(self) -> dict[ConfigType, list[Config]]:
        """Get all configuration files organized by type"""
        configs: dict[ConfigType, list[Config]] = {
            ConfigType.SHELL: [
                Config(self.dotfiles / "shell/.zshenv", self.home / ".zshenv", 0o644),
                Config(self.dotfiles / "shell/.zshrc", self.home / ".zshrc", 0o644),
                Config(self.dotfiles / "shell/.env.zsh", self.home / ".env.zsh", 0o644),
                Config(
                    self.dotfiles / "shell/.aliases.zsh",
                    self.home / ".aliases.zsh",
                    0o644,
                ),
                Config(
                    self.dotfiles / "shell/.functions.zsh",
                    self.home / ".functions.zsh",
                    0o644,
                ),
                Config(self.dotfiles / "shell/.git.zsh", self.home / ".git.zsh", 0o644),
                Config(self.dotfiles / "shell/.dev.zsh", self.home / ".dev.zsh", 0o644),
                Config(
                    self.dotfiles / "shell/.docker.zsh",
                    self.home / ".docker.zsh",
                    0o644,
                ),
                Config(
                    self.dotfiles / "shell/.p10k.zsh", self.home / ".p10k.zsh", 0o644
                ),
            ],
            ConfigType.GIT: [
                Config(
                    self.dotfiles / "git/.gitconfig", self.home / ".gitconfig", 0o644
                ),
                Config(
                    self.dotfiles / "git/.gitignore", self.home / ".gitignore", 0o644
                ),
            ],
            ConfigType.SECURITY: [
                Config(self.dotfiles / "ssh/config", self.home / ".ssh/config", 0o600),
            ],
            ConfigType.APP: [],
        }

        # Add OS-specific configs
        match self.system:
            case "Darwin":
                configs[ConfigType.SHELL].append(
                    Config(
                        source=self.dotfiles / "shell/.darwin.zsh",
                        target=self.home / ".darwin.zsh",
                        mode=0o644,
                    )
                )
                configs[ConfigType.SECURITY].append(
                    Config(
                        source=self.dotfiles / "gnupg/gpg-agent.conf",
                        target=self.home / ".gnupg/gpg-agent.conf",
                        mode=0o600,
                    )
                )
            case "Linux":
                configs[ConfigType.SHELL].append(
                    Config(
                        source=self.dotfiles / "shell/.linux.zsh",
                        target=self.home / ".linux.zsh",
                        mode=0o644,
                    )
                )

        # Add app-specific configs if available
        self._add_app_configs(configs)
        return configs

    def _add_app_configs(self, configs: dict[ConfigType, list[Config]]) -> None:
        """Add application-specific configurations"""
        if shutil.which("kitty"):
            configs[ConfigType.APP].append(
                Config(
                    source=self.dotfiles / "config/kitty/kitty.conf",
                    target=self.config / "kitty/kitty.conf",
                    mode=0o644,
                )
            )

        if shutil.which("htop"):
            configs[ConfigType.APP].append(
                Config(
                    source=self.dotfiles / "config/htop/htoprc",
                    target=self.config / "htop/htoprc",
                    mode=0o644,
                )
            )

        zed_config = self.dotfiles / "config/zed/settings.json"
        if zed_config.exists():
            configs[ConfigType.APP].append(
                Config(
                    source=zed_config,
                    target=self.config
                    / ("zed" if self.system == "Darwin" else "zed.dev")
                    / "settings.json",
                    mode=0o644,
                )
            )

    async def verify_dependencies(self) -> bool:
        """Check if required dependencies are installed"""
        # Check basic dependencies
        for cmd in ("git", "zsh"):
            if not shutil.which(cmd):
                self.log.error(f"Missing required dependency: {cmd}")
                return False

        # Verify Z4H installation - check both the command and the initialization file
        try:
            # Check if z4h is initialized in the current shell
            z4h_init = self.home / ".cache/zsh4humans/v5/z4h.zsh"
            if z4h_init.exists():
                return True

            # Check if z4h command is available
            proc = await asyncio.create_subprocess_exec(
                "zsh",
                "-c",
                "source ~/.zshenv && (( $+functions[z4h] ))",
                stdout=asyncio.subprocess.DEVNULL,
                stderr=asyncio.subprocess.DEVNULL,
            )
            if (await proc.wait()) == 0:
                return True

            self.log.warning("Zsh4Humans not detected - installation required")
            return False

        except Exception as e:
            self.log.error(f"Error checking Z4H installation: {e}")
            return False

    async def setup_directories(self) -> None:
        """Create necessary directories with appropriate permissions"""
        directories = {
            self.home / ".cache" / "zsh": 0o755,
            self.home / ".local" / "state" / "zsh": 0o755,
            self.home / ".local" / "share" / "zsh": 0o755,
            self.home / ".ssh" / "control": 0o700,
            self.config: 0o755,
        }

        for path, mode in directories.items():
            try:
                path.mkdir(parents=True, exist_ok=True)
                path.chmod(mode)
            except Exception as e:
                raise InstallationError(f"Failed to create directory {path}: {e}")

    async def backup_file(self, path: Path) -> None:
        """Create backup of existing file"""
        if not path.exists():
            return

        try:
            self.backup_dir.mkdir(parents=True, exist_ok=True)
            backup_path = self.backup_dir / path.name

            # Handle duplicate backup names
            if backup_path.exists():
                for i in range(1, 100):
                    new_path = self.backup_dir / f"{path.name}.{i}"
                    if not new_path.exists():
                        backup_path = new_path
                        break

            shutil.copy2(path, backup_path)
            self.log.info(f"Backed up: {path} → {backup_path}")
        except Exception as e:
            raise InstallationError(f"Failed to backup {path}: {e}")

    async def create_symlink(self, config: Config) -> bool:
        """Create symbolic link with proper permissions"""
        if self.dry_run:
            self.log.info(f"Would link: {config.target} → {config.source}")
            return True

        try:
            if config.target.exists() or config.target.is_symlink():
                if not self.force and config.target.exists():
                    self.log.warning(f"Skipping existing file: {config.target}")
                    return False
                await self.backup_file(config.target)
                config.target.unlink()

            config.target.parent.mkdir(parents=True, exist_ok=True)
            config.target.symlink_to(config.source)
            config.target.chmod(config.mode)
            self.log.info(f"Linked: {config.target} → {config.source}")
            return True
        except Exception as e:
            if config.required:
                raise InstallationError(
                    f"Failed to link required file {config.target}: {e}"
                )
            self.log.error(f"Failed to link {config.target}: {e}")
            return False

    async def create_local_customization(self) -> None:
        """Create local customization file"""
        if self.dry_run:
            self.log.info("Would create local customization file")
            return

        try:
            local_zshrc = self.home / ".zshrc.local"
            if not local_zshrc.exists():
                local_zshrc.write_text(
                    "# Local ZSH customizations\n"
                    "# This file is sourced at the end of .zshrc\n"
                )
                local_zshrc.chmod(0o644)
                self.log.info("Created local customization file")
        except Exception as e:
            self.log.error(f"Failed to create local customization file: {e}")

    async def install(self) -> bool:
        """Install all configuration files"""
        try:
            await self.verify_dependencies()
            configs = self.get_configs()
            success = True

            for config_type, config_list in configs.items():
                self.log.info(f"\nInstalling {config_type.value} configurations...")
                for config in config_list:
                    if not await self.create_symlink(config):
                        success = False

            await self.create_local_customization()
            return success

        except DotfilesError as e:
            self.log.error(str(e))
            return False

    @classmethod
    async def run_install(cls, args: argparse.Namespace) -> int:
        """Run the installation process"""
        try:
            async with cls(dry_run=args.dry_run, force=args.force) as installer:
                if await installer.install():
                    installer.log.info("\n✨ Dotfiles installation complete!")
                    installer.log.info(f"Backups stored in: {installer.backup_dir}")
                    installer.log.info(
                        "Please restart your shell for changes to take effect."
                    )
                    return 0
                return 1
        except Exception as e:
            print(f"Fatal error: {e}", file=sys.stderr)
            return 1


def parse_args() -> argparse.Namespace:
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(description="Install dotfiles")
    parser.add_argument(
        "--dry-run", action="store_true", help="Show what would be done"
    )
    parser.add_argument(
        "--force", action="store_true", help="Force overwrite existing files"
    )
    return parser.parse_args()


if __name__ == "__main__":
    sys.exit(asyncio.run(DotfilesInstaller.run_install(parse_args())))
