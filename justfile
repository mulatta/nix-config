# default recipe to display help information
@default:
  just --list

# ========== Host Management ==========

# Bootstrap a new NixOS host using nixos-anywhere
@bootstrap HOSTNAME TARGET *ARGS:
    chmod +x utils/scripts/bootstrap.sh
    ./utils/scripts/bootstrap.sh {{HOSTNAME}} {{TARGET}} {{ARGS}}
# Deploy configuration to existing host
deploy HOSTNAME TARGET:
    #!/usr/bin/env bash
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS: Use nix run to execute nixos-rebuild
        echo "🍎 Deploying from macOS to NixOS..."
        nix run nixpkgs#nixos-rebuild -- switch --flake .#{{HOSTNAME}} --target-host root@{{TARGET}}
    else
        # Linux: Use nixos-rebuild directly
        echo "🐧 Deploying from NixOS/Linux..."
        nixos-rebuild switch --flake .#{{HOSTNAME}} --target-host root@{{TARGET}}
    fi

# Test configuration without switching (cross-platform)
test HOSTNAME TARGET:
    #!/usr/bin/env bash
    if [[ "$OSTYPE" == "darwin"* ]]; then
        nix run nixpkgs#nixos-rebuild -- test --flake .#{{HOSTNAME}} --target-host root@{{TARGET}}
    else
        nixos-rebuild test --flake .#{{HOSTNAME}} --target-host root@{{TARGET}}
    fi

# Dry run - show what would be built (cross-platform)
dry-run HOSTNAME TARGET:
    #!/usr/bin/env bash
    if [[ "$OSTYPE" == "darwin"* ]]; then
        nix run nixpkgs#nixos-rebuild -- dry-run --flake .#{{HOSTNAME}} --target-host root@{{TARGET}}
    else
        nixos-rebuild dry-run --flake .#{{HOSTNAME}} --target-host root@{{TARGET}}
    fi

# ========== SOPS Management ==========

# Edit secrets for a specific host
secrets-edit HOSTNAME:
    sops hosts/{{HOSTNAME}}/secrets.yaml

# Edit common secrets
secrets-edit-common:
    sops hosts/common/secrets.yaml

# Rotate SOPS keys (update all secrets with new keys)
secrets-rotate:
    #!/usr/bin/env bash
    find . -name "*.yaml" -path "*/secrets/*" -exec sops updatekeys {} \;
    echo "✅ All SOPS files updated with current keys"

# Validate SOPS configuration
secrets-validate:
    #!/usr/bin/env bash
    echo "🔍 Validating SOPS configuration..."
    for file in $(find . -name "secrets.yaml"); do
        echo "Checking $file"
        sops -d "$file" > /dev/null && echo "✅ $file" || echo "❌ $file"
    done

# ========== Key Management ==========

# Setup YubiKey SSH agent forwarding
setup-yubikey-agent:
    chmod +x utils/scripts/yubikey-agent-setup.sh
    ./utils/scripts/yubikey-agent-setup.sh

# Connect to host with YubiKey agent forwarding
ssh-agent HOSTNAME TARGET:
    @echo "🔑 Connecting with YubiKey agent forwarding..."
    @echo "💡 Make sure your YubiKey is connected"
    ssh -A root@{{TARGET}}

# Test YubiKey agent forwarding
test-yubikey-agent TARGET:
    @echo "🧪 Testing YubiKey agent forwarding to {{TARGET}}"
    ssh -A root@{{TARGET}} 'ssh-add -l && echo "✅ YubiKey keys accessible on remote"'

# Show current age key for a host
show-age-key HOSTNAME:
    #!/usr/bin/env bash
    if [[ -f "hosts/{{HOSTNAME}}/ssh_host_ed25519_key.pub" ]]; then
        cat "hosts/{{HOSTNAME}}/ssh_host_ed25519_key.pub" | ssh-to-age
    else
        echo "❌ SSH host key not found for {{HOSTNAME}}"
        echo "💡 Run: just prepare-keys {{HOSTNAME}}"
    fi

# Convert SSH public key to age format
ssh-to-age SSH_KEY:
    echo "{{SSH_KEY}}" | ssh-to-age

# Generate new age key
age-keygen:
    age-keygen

# Extract SSH host key from remote machine
ssh-hostkey TARGET:
    ssh-keyscan {{TARGET}} | grep ed25519

# ========== GPG/Age Key Backup ==========
# Back-up a GPG key
key-backup KEYID:
    just export-sec {{KEYID}}
    paperkey --secret-key "/tmp/{{KEYID}}_backup.gpg" --output "/tmp/{{KEYID}}_paper.txt"
    lpr "/tmp/{{KEYID}}_paper.txt"
    @echo "📄 Paper backup printed for key {{KEYID}}"

# Export GPG secret key
export-sec KEYID:
    gpg --export-secret-keys {{KEYID}} > "/tmp/{{KEYID}}_backup.gpg"
    @echo "🔐 Secret key exported to /tmp/{{KEYID}}_backup.gpg"
    
# Export GPG public key
export-pub KEYID:
    gpg --export {{KEYID}} > "/tmp/{{KEYID}}_pub.gpg"
    @echo "🔑 Public key exported to /tmp/{{KEYID}}_pub.gpg"

# Recover GPG key from paper backup
key-recovery KEYID:
    paperkey --pubring "/tmp/{{KEYID}}_pub.gpg" --secrets "/tmp/{{KEYID}}_paper.txt" | gpg --import
    @echo "🔄 Key {{KEYID}} recovered from paper backup"

# ========== Utilities ==========

# Show system information for all hosts
info:
    #!/usr/bin/env bash
    echo "📋 NixOS Configuration Information"
    echo "==================================="
    echo "Available hosts:"
    ls -1 hosts/ | grep -v common | sed 's/^/  - /'
    echo ""
    echo "Current flake inputs:"
    nix flake metadata --json | jq -r '.locks.nodes.root.inputs | keys[]' | sed 's/^/  - /'

# Clean up build artifacts
clean:
    nix-collect-garbage
    @echo "🧹 Build artifacts cleaned"

# Emergency SSH access (disable password, enable temporary access)
emergency-access TARGET:
    #!/usr/bin/env bash
    echo "🚨 Setting up emergency SSH access to {{TARGET}}"
    echo "This will temporarily enable password authentication"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ssh root@{{TARGET}} "sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl reload sshd"
        echo "✅ Emergency access enabled. Don't forget to disable it later!"
    fi
