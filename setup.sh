#!/usr/bin/env zsh

# ssh
ssh-keygen -t ed25519 -C "nijaru0x@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# gh
sudo dnf install 'dnf-command(config-manager)'
sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
sudo dnf install gh
gh auth login

# gpg
gpg --full-generate-key
gpg --list-secret-keys --keyid-format=long
