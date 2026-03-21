---
name: age-chezmoi
description: Use for managing encrypted secrets and sensitive dotfiles using age and chezmoi.
allowed-tools: Bash, Read, Write, Edit
---

# Secrets Management (age + chezmoi)

## 🎯 Core Mandates

- **Master Key Path:** Symlinked at `~/.config/age/keys.txt` (Source: iCloud Developer folder).
- **Never plaintext:** Do NOT commit `.chezmoidata.yaml` in plaintext. Encrypt it immediately.
- **Atomic Operations:** Encrypt, Apply, and Delete plaintext within the same command sequence.

## 🛠️ Technical Standards

### 1. Update Secrets Workflow
Execute this exact sequence to update API keys or secrets:
1. `edit .chezmoidata.yaml` (Add/Update keys)
2. `age --encrypt -r <public-key> .chezmoidata.yaml > .chezmoidata.yaml.age`
3. `chezmoi apply --force`
4. `rm .chezmoidata.yaml`

### 2. Verification
- Verify the encrypted file exists: `ls .chezmoidata.yaml.age`.
- Verify the plaintext file is GONE: `ls .chezmoidata.yaml` (should fail).
- Check decryption works: `chezmoi data` (should show the decrypted values).

### 3. Key Management
- Public Key: Find in the `age-keys.txt` file.
- Do NOT log or print the keys or the plaintext `.chezmoidata.yaml` content.

## 🚫 Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "I'll delete the file later" | If the session crashes, the secret is left exposed on disk. |
| "I'll use a git ignore" | Plaintext secrets in the source directory are a security risk even if ignored. |
| "Chezmoi handles it" | Chezmoi only manages the file; YOU must handle the age encryption manually. |
