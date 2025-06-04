# nix-config

A modern NixOS configuration with automated deployment via nixos-anywhere, YubiKey-based authentication, and SOPS secret management.

## Core Concepts

- Hosts are defined as combination of hardware & user profiles
- Each hosts possess their own ROLE
- **Automated Bootstrap**: Use nixos-anywhere for remote installation
- **YubiKey Integration**: FIDO2-based SSH authentication
- **Secret Management**: SOPS with age encryption

## Hosts

- `rhesus`: My "personal laptop/desktop" user profile
- `mulatta`: My "personal server/backend" user profile

## Quick Start

### Bootstrap a New Host

```bash
# 1. Setup environment
./setup.sh

# 2. Bootstrap new host (recommended - solves SOPS chicken-egg problem)
just bootstrap-full mulatta <target-ip>

# 3. Deploy configuration updates (optional)
just deploy mulatta <target-ip>
```

### Available Commands

```bash
# Host management
just prepare-keys mulatta                       # Generate SSH keys & update SOPS
just bootstrap mulatta nixos@192.168.1.100     # Basic bootstrap with pre-keys
just bootstrap-hw mulatta nixos@192.168.1.100  # With hardware config (recommended)
just bootstrap-full mulatta 192.168.1.100      # Complete automated workflow
just extract-keys mulatta 192.168.1.100        # Legacy: extract keys after install
just deploy mulatta 192.168.1.100              # Deploy configuration
just test mulatta 192.168.1.100                # Test configuration

# Development
just check                                      # Validate flake
just build mulatta                              # Build locally
just fmt                                        # Format code

# Secret management
just secrets-edit mulatta                      # Edit host secrets
just secrets-validate                          # Validate SOPS config
just secrets-rotate                            # Update all secrets

# Key management
just ssh-to-age "ssh-ed25519 AAAA..."          # Convert SSH to age
just ssh-hostkey 192.168.1.100                # Get host key

# Utilities
just info                                       # Show configuration info
just clean                                      # Clean build artifacts
just emergency-access 192.168.1.100           # Emergency SSH access
```

## Features

### 🚀 Automated Deployment
- **Pre-generated keys**: SSH keys generated locally and sent with installation
- **SOPS immediate availability**: Secrets can be decrypted from first boot
- **Hardware detection**: Automatic hardware configuration generation
- **No chicken-egg problem**: Solves SOPS bootstrap complexity

### 🔐 Security
- **YubiKey FIDO2**: Hardware-based SSH authentication
- **SOPS encryption**: Secure secret management with age
- **Minimal attack surface**: Hardened default configurations

### 🔧 Developer Experience
- **Just recipes**: Simple command-line interface
- **Validation**: Automatic configuration checking
- **Documentation**: Comprehensive guides and examples

## Directory Structure

```
.
├── home/                 # User configuration profiles
│   └── seungwon/        # User-specific configurations
├── hosts/               # Host-specific configurations
│   ├── common/          # Shared configurations
│   ├── mulatta/         # Server configuration
│   └── rhesus/          # Desktop configuration
├── modules/             # Reusable Nix modules
├── overlays/            # Nix package overlays
├── pkgs/               # Custom package definitions
├── scripts/            # Bootstrap and utility scripts
├── templates/          # Configuration templates
├── .sops.yaml          # SOPS configuration
└── justfile            # Command recipes
```

## Bootstrap Process

The bootstrap process completely solves the SOPS chicken-egg problem:

### New Approach: Pre-generated Keys
1. **Local key generation**: SSH host keys generated on local machine
2. **SOPS configuration update**: `.sops.yaml` updated with new age keys immediately
3. **Installation with keys**: nixos-anywhere installs with pre-configured keys
4. **Immediate SOPS availability**: Secrets can be decrypted from first boot

### Legacy Approach (Deprecated)
1. Install first without SOPS secrets
2. Extract keys after installation
3. Update SOPS configuration
4. Redeploy with secrets

### Why the New Approach is Better
✅ **One-step installation**: Complete setup in single command  
✅ **SOPS from day one**: No bootstrap without secrets  
✅ **Predictable outcome**: Same keys every time  
✅ **No temporary configs**: Full security from start

## YubiKey Setup

This configuration supports YubiKey FIDO2 SSH authentication:

```bash
# Generate FIDO2 SSH key on YubiKey
ssh-keygen -t ed25519-sk -O resident -O application=ssh:main
ssh-keygen -t ed25519-sk -O resident -O application=ssh:backup

# Add public keys to configuration
# Keys are already configured in home/seungwon/keys/
```

## Secret Management

Secrets are managed using SOPS with age encryption:

```bash
# Edit secrets
just secrets-edit mulatta
just secrets-edit-common

# Validate configuration
just secrets-validate

# Rotate keys (after adding new hosts)
just secrets-rotate
```

## Troubleshooting

### SSH Connection Issues
- Ensure target machine is booted from NixOS installer
- Check network connectivity and firewall settings
- Use `just emergency-access` for password authentication

### YubiKey Issues
- Ensure YubiKey is physically connected
- Touch YubiKey when prompted for authentication
- Use backup YubiKey if primary fails

### SOPS Decryption Issues
- Run `just secrets-validate` to check key configuration
- Verify age keys in `.sops.yaml` match actual host keys
- Use `just extract-keys --update-sops` to fix key mismatches

## Contributing

When making changes, please follow the commit conventions below for automated changelog generation.

## Directory Structure

```
.
├── home/                 # User configuration profiles
│   └── seungwon/        # User-specific configurations
├── hosts/               # Host-specific configurations
├── modules/             # Reusable Nix modules
├── overlays/            # Nix package overlays
├── pkgs/               # Custom package definitions
└── templates/          # Configuration templates
```

## Commit Conventions

This project uses structured commit messages to automatically generate organized release notes using GoReleaser. Follow these conventions when making commits:

### Commit Format

```
type(scope): description
```

- **type**: Describes the kind of change (feat, fix, chore, etc.)
- **scope**: The area of the codebase being changed
- **description**: A brief description of the change

### Types

- `feat`: New features or enhancements
- `fix`: Bug fixes
- `chore`: Maintenance tasks (excluded from changelog when scope is "nix")
- `docs`: Documentation changes
- `refactor`: Code refactoring without feature changes
- `test`: Adding or updating tests
- `style`: Formatting changes
- `perf`: Performance improvements

### Scopes

Your commit will be categorized in the changelog based on these scopes:

| Category     | Scopes                                                |
| ------------ | ----------------------------------------------------- |
| System       | `system`, `fish`, `fzf`, `ssh`, `core`, `pkg`, `pkgs` |
| Nix          | `nix`                                                 |
| Darwin/macOS | `darwin`, `macos`                                     |
| Linux        | `linux`, `nixos`                                      |
| Editor       | `helix`, `vim`, `nvim`, `neovim`                      |
| Tmux         | `zellij`, `tmux`                                      |
| Git          | `git`, `gh`                                           |
| Terminals    | `kitty`, `wezterm`, `rio`, `ghostty`, `alacritty`     |
| AI           | `ai`                                                  |

### Examples

```
feat(nix): Add Helix editor package
fix(macos): Resolve keyboard shortcut conflict in Yabai
refactor(vim): Simplify plugin configuration
chore(system): Update package versions
feat(tmux): Add new status bar layout
```

When creating a release, GoReleaser will automatically organize these commits into a structured changelog with sections for improvements, fixes, and other changes within each category.
