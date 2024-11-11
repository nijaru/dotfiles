#!/usr/bin/env python3

import logging
import platform
import shutil
import stat
import subprocess
import sys
import urllib.request
from contextlib import contextmanager
from datetime import datetime
from pathlib import Path
from typing import Dict, Optional, Set


class DotfilesInstaller:
    def __init__(self):
        self.home = Path.home()
        self.dotfiles_dir = self.home / "github" / "dotfiles"
        self.config_dir = self.home / ".config"

        # New backup structure
        self.backups_parent = self.home / ".dotfiles_backups"
        self.current_backup_dir = (
            self.backups_parent / f"backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        )

        self.system = platform.system()

        # Track operations for rollback
        self.created_symlinks: Set[Path] = set()
        self.created_dirs: Set[Path] = set()
        self.modified_permissions: Dict[Path, int] = {}

        # Add installation flags
        self.force_install = "--force" in sys.argv
        self.skip_backups = "--no-backup" in sys.argv
        self.dry_run = "--dry-run" in sys.argv

        # Setup logging
        self.setup_logging()

    def setup_logging(self):
        """Configure logging with colored output"""

        class ColorFormatter(logging.Formatter):
            COLORS = {
                "INFO": "\033[92m",  # Green
                "WARNING": "\033[93m",  # Yellow
                "ERROR": "\033[91m",  # Red
                "CRITICAL": "\033[91m",  # Red
                "RESET": "\033[0m",
            }

            def format(self, record):
                color = self.COLORS.get(record.levelname, self.COLORS["RESET"])
                record.msg = f"{color}{record.msg}{self.COLORS['RESET']}"
                return super().format(record)

        handler = logging.StreamHandler()
        handler.setFormatter(ColorFormatter("%(message)s"))

        self.log = logging.getLogger("dotfiles")
        self.log.addHandler(handler)
        self.log.setLevel(logging.INFO)

    def print_help(self):
        """Display usage information"""
        help_text = """
        Dotfiles Installer

        Usage: ./install.py [options]

        Options:
          --force      Force installation, overwriting existing files
          --no-backup  Skip creating backups of existing files
          --dry-run    Show what would be done without making changes
          --help      Show this help message
        """
        print(help_text)
        sys.exit(0)

    def verify_dependencies(self) -> bool:
        """Check if required dependencies are installed"""
        dependencies = {
            "git": "Git is required for dotfiles management",
            "zsh": "Zsh shell is required",
            "z4h": "Z4H (Zsh for Humans) is required - install from https://github.com/romkatv/zsh4humans",
        }

        missing = []
        for cmd, msg in dependencies.items():
            if not shutil.which(cmd):
                missing.append(f"{cmd}: {msg}")

        if missing:
            self.log.error("Missing required dependencies:")
            for msg in missing:
                self.log.error(f"  - {msg}")
            return False
        return True

    def check_git_repo(self) -> bool:
        """Verify dotfiles directory is a git repository"""
        try:
            if not (self.dotfiles_dir / ".git").exists():
                self.log.error(f"Not a git repository: {self.dotfiles_dir}")
                return False
            return True
        except Exception as e:
            self.log.error(f"Failed to check git repository: {e}")
            return False

    @contextmanager
    def rollback_context(self):
        """Context manager for handling installation with rollback capability"""
        try:
            yield
        except Exception as e:
            self.log.error(f"Installation failed: {str(e)}")
            self.rollback()
            raise
        else:
            self.log.info("✓ Installation completed successfully")

    def rollback(self):
        """Rollback changes in case of failure"""
        self.log.warning("Rolling back changes...")

        # Remove created symlinks
        for link in self.created_symlinks:
            try:
                if link.is_symlink():
                    link.unlink()
                    self.log.info(f"Removed symlink: {link}")
            except Exception as e:
                self.log.error(f"Failed to remove symlink {link}: {e}")

        # Restore original permissions
        for path, mode in self.modified_permissions.items():
            try:
                path.chmod(mode)
                self.log.info(f"Restored permissions for: {path}")
            except Exception as e:
                self.log.error(f"Failed to restore permissions for {path}: {e}")

        # Remove created directories (in reverse order)
        for dir_path in sorted(self.created_dirs, reverse=True):
            try:
                if dir_path.exists() and dir_path.is_dir():
                    shutil.rmtree(dir_path)
                    self.log.info(f"Removed directory: {dir_path}")
            except Exception as e:
                self.log.error(f"Failed to remove directory {dir_path}: {e}")

    def setup_backup_directory(self):
        """Initialize backup directory structure"""
        try:
            # Create parent backup directory if it doesn't exist
            self.backups_parent.mkdir(mode=0o700, exist_ok=True)

            # Create new backup directory for this run
            self.current_backup_dir.mkdir(mode=0o700)

            # Track created directory for potential rollback
            self.created_dirs.add(self.current_backup_dir)

            self.log.info(f"Created backup directory: {self.current_backup_dir}")

            # Clean old backups (keep last 5)
            self.cleanup_old_backups()

            return True
        except Exception as e:
            self.log.error(f"Failed to setup backup directory: {e}")
            return False

    def cleanup_old_backups(self, keep_last: int = 5):
        """Remove old backup directories, keeping the specified number of most recent ones"""
        try:
            # Get all backup directories sorted by name (which includes timestamp)
            backup_dirs = sorted(
                [
                    d
                    for d in self.backups_parent.iterdir()
                    if d.is_dir() and d.name.startswith("backup_")
                ],
                reverse=True,
            )

            # Remove old backups
            for old_backup in backup_dirs[keep_last:]:
                shutil.rmtree(old_backup)
                self.log.info(f"Removed old backup: {old_backup}")
        except Exception as e:
            self.log.warning(f"Failed to cleanup old backups: {e}")

    def link_file(self, src: Path, dest: Path, mode: Optional[int] = None) -> bool:
        """Create a symbolic link with backup of existing files"""
        try:
            if self.dry_run:
                self.log.info(f"Would link: {dest} -> {src}")
                return True

            # Ensure parent directory exists
            dest.parent.mkdir(parents=True, exist_ok=True)
            self.created_dirs.add(dest.parent)

            # Handle existing file/symlink
            if dest.exists() or dest.is_symlink():
                if not self.force_install:
                    self.log.warning(f"File exists: {dest} (use --force to overwrite)")
                    return False

                # Backup existing file if backups aren't disabled
                if not self.skip_backups:
                    if dest.exists():
                        self.modified_permissions[dest] = stat.S_IMODE(
                            dest.stat().st_mode
                        )

                    backup_path = self.current_backup_dir / dest.name
                    if backup_path.exists():
                        count = 1
                        while backup_path.exists():
                            backup_path = (
                                self.current_backup_dir / f"{dest.name}.{count}"
                            )
                            count += 1

                    if dest.exists():
                        shutil.copy2(dest, backup_path)

                dest.unlink()

            # Create new symlink
            dest.symlink_to(src)
            self.created_symlinks.add(dest)

            # Set file permissions if specified
            if mode is not None:
                dest.chmod(mode)
                self.modified_permissions[dest] = mode

            self.log.info(f"✓ Linked {dest} -> {src}")
            return True

        except Exception as e:
            self.log.error(f"⚠️  Failed to link {dest}: {str(e)}")
            return False

    def install_zsh4humans(self) -> bool:
        """Install Zsh4Humans if not already installed"""
        try:
            # Check if z4h is already installed
            result = subprocess.run(
                ["command", "-v", "z4h"], capture_output=True, text=True
            )

            if result.returncode == 0:
                self.log.info("✓ Zsh4Humans already installed, skipping installation")
                return True

            self.log.info("Installing Zsh4Humans...")

            # Fetch the installation script
            z4h_url = "https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install"

            try:
                response = urllib.request.urlopen(z4h_url)
                install_script = response.read().decode()
            except Exception as e:
                self.log.error(f"Failed to download Zsh4Humans: {e}")
                return False

            # Execute installation script with TTY allocation
            result = subprocess.run(
                ["sh", "-c", install_script],
                stdin=sys.stdin,
                stdout=sys.stdout,
                stderr=sys.stderr,
            )

            if result.returncode != 0:
                self.log.error("Zsh4Humans installation failed")
                return False

            return True

        except Exception as e:
            self.log.error(f"Failed to install Zsh4Humans: {e}")
            return False

    def install_package_manager(self) -> bool:
        """Install and configure package manager based on OS"""
        try:
            if self.system == "Darwin":
                if not shutil.which("brew"):
                    self.log.info("Installing Homebrew...")
                    install_cmd = '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
                    subprocess.run(install_cmd, shell=True, check=True)

                # Install packages from Brewfile
                brewfile = self.dotfiles_dir / "homebrew" / "Brewfile"
                if brewfile.exists():
                    self.log.info("Installing Homebrew packages...")
                    result = subprocess.run(["brew", "bundle", "--file", str(brewfile)])
                    if result.returncode != 0:
                        self.log.warning("Some Homebrew packages failed to install")

            elif self.system == "Linux":
                # Configure DNF if on Fedora/RHEL
                if shutil.which("dnf"):
                    dnf_conf = self.dotfiles_dir / "system" / "dnf.conf"
                    if dnf_conf.exists():
                        try:
                            subprocess.run(
                                ["sudo", "mkdir", "-p", "/etc/dnf"], check=True
                            )
                            subprocess.run(
                                ["sudo", "cp", str(dnf_conf), "/etc/dnf/dnf.conf"],
                                check=True,
                            )
                            self.log.info("✓ DNF configuration updated")
                        except subprocess.CalledProcessError as e:
                            self.log.error(f"Failed to configure DNF: {e}")
                            return False

            return True

        except Exception as e:
            self.log.error(f"Failed to configure package manager: {e}")
            return False

    def install_security_components(self) -> bool:
        """Install SSH and GPG configurations"""
        try:
            # SSH setup
            ssh_dir = self.home / ".ssh"
            ssh_dir.mkdir(mode=0o700, exist_ok=True)
            self.created_dirs.add(ssh_dir)

            ssh_control_dir = ssh_dir / "control"
            ssh_control_dir.mkdir(mode=0o700, exist_ok=True)
            self.created_dirs.add(ssh_control_dir)

            if not self.link_file(
                self.dotfiles_dir / "ssh" / "config", ssh_dir / "config", mode=0o600
            ):
                return False

            # GPG setup (primarily for macOS)
            if self.system == "Darwin":
                gpg_dir = self.home / ".gnupg"
                gpg_dir.mkdir(mode=0o700, exist_ok=True)
                self.created_dirs.add(gpg_dir)

                if not self.link_file(
                    self.dotfiles_dir / "gnupg" / "gpg-agent.conf",
                    gpg_dir / "gpg-agent.conf",
                    mode=0o600,
                ):
                    return False

            return True

        except Exception as e:
            self.log.error(f"Failed to install security components: {e}")
            return False

    def install_git_config(self) -> bool:
        """Install Git configuration files"""
        try:
            git_files = [
                ("git/.gitconfig", ".gitconfig"),
                ("git/.gitignore", ".gitignore"),
            ]

            for src_path, dest_name in git_files:
                if not self.link_file(
                    self.dotfiles_dir / src_path, self.home / dest_name
                ):
                    return False

            return True

        except Exception as e:
            self.log.error(f"Failed to install Git configuration: {e}")
            return False

    def install_shell_config(self) -> bool:
        """Install shell configuration files"""
        try:
            shell_files = [
                ("shell/.zshrc", ".zshrc"),  # Direct link to our .zshrc
                ("shell/.zshenv", ".zshenv"),
                ("shell/.aliases", ".aliases"),
                ("shell/.aliases-git", ".aliases-git"),
                ("shell/.env.zsh", ".env.zsh"),
                ("shell/.functions.zsh", ".functions.zsh"),
                ("shell/.p10k.zsh", ".p10k.zsh"),
            ]

            # OS-specific shell configuration
            if self.system == "Darwin":
                shell_files.append(("shell/.darwin.zsh", ".darwin.zsh"))
            elif self.system == "Linux":
                shell_files.append(("shell/.linux.zsh", ".linux.zsh"))

            for src_path, dest_name in shell_files:
                if not self.link_file(
                    self.dotfiles_dir / src_path, self.home / dest_name
                ):
                    return False

            return True

        except Exception as e:
            self.log.error(f"Failed to install shell configuration: {e}")
            return False

    def install_app_configs(self) -> bool:
        """Install application-specific configurations"""
        try:
            # Kitty terminal configuration
            kitty_dir = self.config_dir / "kitty"
            kitty_dir.mkdir(parents=True, exist_ok=True)
            self.created_dirs.add(kitty_dir)

            if not self.link_file(
                self.dotfiles_dir / "config/kitty/kitty.conf", kitty_dir / "kitty.conf"
            ):
                return False

            # Htop configuration
            htop_dir = self.config_dir / "htop"
            htop_dir.mkdir(parents=True, exist_ok=True)
            self.created_dirs.add(htop_dir)

            if not self.link_file(
                self.dotfiles_dir / "config/htop/htoprc", htop_dir / "htoprc"
            ):
                return False

            # Zed configuration (OS-specific paths)
            zed_config_src = self.dotfiles_dir / "config/zed/settings.json"
            if self.system == "Darwin":
                zed_dir = self.config_dir / "zed"
            else:
                zed_dir = self.config_dir / "zed.dev"

            zed_dir.mkdir(parents=True, exist_ok=True)
            self.created_dirs.add(zed_dir)

            if not self.link_file(zed_config_src, zed_dir / "settings.json"):
                return False

            return True

        except Exception as e:
            self.log.error(f"Failed to install application configs: {e}")
            return False

    def run(self):
        """Main installation process"""
        # Show help if requested
        if "--help" in sys.argv:
            self.print_help()

        with self.rollback_context():
            # Verify environment
            if not self.verify_dependencies():
                raise Exception("Missing required dependencies")

            if not self.check_git_repo():
                raise Exception("Invalid git repository")

            # Setup backup directory if not skipped
            if not self.skip_backups and not self.dry_run:
                if not self.setup_backup_directory():
                    raise Exception("Failed to setup backup directory")

            # Installation steps
            steps = [
                ("Installing security components", self.install_security_components),
                ("Installing Git configuration", self.install_git_config),
                ("Installing shell configuration", self.install_shell_config),
                ("Installing application configs", self.install_app_configs),
            ]

            for step_name, step_func in steps:
                self.log.info(f"\n=== {step_name} ===")
                if not step_func():
                    raise Exception(f"Failed during: {step_name}")

            if self.dry_run:
                self.log.info("\n✨ Dry run completed - no changes were made")
            else:
                self.log.info("\n✨ Dotfiles installation complete!")
                if not self.skip_backups:
                    self.log.info(
                        f"Your old configs have been backed up to {self.current_backup_dir}"
                    )
                self.log.info("Please restart your shell for changes to take effect.")


if __name__ == "__main__":
    installer = DotfilesInstaller()
    installer.run()
