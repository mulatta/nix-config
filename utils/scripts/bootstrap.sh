#!/usr/bin/env bash

set -euo pipefail

# color scheme
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# print usage
usage() {
    cat << EOF
Usage: $0 <hostname> <target-host> [nixos-anywhere-options...]

Arguments:
    hostname                 NixOS configuration name (e.g., myserver)
    target-host             SSH target (e.g., root@192.168.1.100)
    [nixos-anywhere-options] Additional options for nixos-anywhere

Example:
    $0 myserver root@192.168.1.100
    $0 myserver root@192.168.1.100 --debug --build-on-remote

Environment variables:
    EDITOR                  Editor to use for .sops.yaml (default: \$EDITOR or nano)
    FLAKE_PATH             Path to flake directory (default: current directory)
EOF
}

# loggin functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }


# check parameters
if [ $# -lt 2 ]; then
    usage
    exit 1
fi

HOSTNAME="$1"
TARGET_HOST="$2"
shift 2
NIXOS_ANYWHERE_ARGS=("$@")

# set environment variables
EDITOR="${EDITOR:-nano}"
FLAKE_PATH="${FLAKE_PATH:-.}"
SOPS_FILE="${FLAKE_PATH}/.sops.yaml"


log_info "Starting nixos-anywhere deployment for ${HOSTNAME} to ${TARGET_HOST}"

# 1. create temp dir
temp=$(mktemp -d)
cleanup() {
    log_info "Cleaning up temporary files..."
    rm -rf "$temp"
}
trap cleanup EXIT

log_info "Created temporary directory: $temp"

# 2. generate ssh key
ssh_key_dir="$temp/etc/ssh"
mkdir -p "$ssh_key_dir"

log_info "Generating SSH host key for $HOSTNAME..."
ssh-keygen -t ed25519 -f "$ssh_key_dir/ssh_host_ed25519_key" -N "" -C "$HOSTNAME" -q

# set key permission
chmod 600 "$ssh_key_dir/ssh_host_ed25519_key"
chmod 644 "$ssh_key_dir/ssh_host_ed25519_key.pub"

log_success "SSH key generated successfully"

# 3. convert ssh key to age key
log_info "Converting SSH key to age format..."
age_key=$(ssh-to-age < "$ssh_key_dir/ssh_host_ed25519_key.pub")
log_success "Age key generated: $age_key"

# 4. .sops.yaml create .sops.yaml backup
if [ -f "$SOPS_FILE" ]; then
    cp "$SOPS_FILE" "$SOPS_FILE.backup.$(date +%s)"
    log_info "Backup created: $SOPS_FILE.backup.$(date +%s)"
fi

# 5. notice for editing .sops.yaml
echo
echo -e "${YELLOW}=== SSH Key Information ===${NC}"
echo -e "Hostname: ${HOSTNAME}"
echo -e "Age Key:  ${age_key}"
echo
echo -e "${YELLOW}=== Next Steps ===${NC}"
echo -e "1. The .sops.yaml file will now open in your editor"
echo -e "2. Add the age key above to the appropriate section for ${HOSTNAME}"
echo -e "3. Save and close the file to continue the deployment"
echo
echo -e "${YELLOW}=== Example .sops.yaml entry ===${NC}"
cat << EOF
keys:
  - &admin_key your_admin_key_here
  - &${HOSTNAME}_key ${age_key}

creation_rules:
  - path_regex: secrets/.*\.yaml$
    key_groups:
    - age:
      - *admin_key
      - *${HOSTNAME}_key
EOF
echo
echo -e "Press Enter to open .sops.yaml in ${EDITOR}..."

read -r

# record modification time
if [ -f "$SOPS_FILE" ]; then
    original_mtime=$(stat -c %Y "$SOPS_FILE" 2>/dev/null || stat -f %m "$SOPS_FILE" 2>/dev/null)
else
    original_mtime=0
fi

# 6. edit .sops.yaml
log_info "Opening .sops.yaml for editing..."
"$EDITOR" "$SOPS_FILE"

# 7. detect file changes
log_info "Waiting for .sops.yaml changes to be saved..."

# wait until file changes
while true; do
    if [ -f "$SOPS_FILE" ]; then
        current_mtime=$(stat -c %Y "$SOPS_FILE" 2>/dev/null || stat -f %m "$SOPS_FILE" 2>/dev/null)
        if [ "$current_mtime" -gt "$original_mtime" ]; then
            log_success ".sops.yaml has been updated"
            break
        fi
    fi
    sleep 1
done

# 9. re-encrypt previous secretes
if ls "${FLAKE_PATH}"/secrets/*.yaml &> /dev/null; then
    echo
    read -p "Re-encrypt existing sops files with new key? (y/N): " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Re-encrypting sops files..."
        for sops_file in "${FLAKE_PATH}"/secrets/*.yaml; do
            if [ -f "$sops_file" ]; then
                log_info "Updating keys for $sops_file"
                sops updatekeys "$sops_file"
            fi
        done
        log_success "Sops files re-encrypted"
    fi
fi

# 10. copy SSH pub key to host dir (for knownHosts)
host_dir="${FLAKE_PATH}/${HOSTNAME}"
if [ -d "$host_dir" ]; then
    log_info "Copying SSH public key to $host_dir for knownHosts..."
    cp "$ssh_key_dir/ssh_host_ed25519_key.pub" "$host_dir/"
    log_success "SSH public key copied to host directory"
else
    log_warning "Host directory $host_dir not found, skipping public key copy"
fi

# copy ssh pubkey to flake directory
cp "$ssh_key_dir/ssh_host_ed25519_key.pub" "$FLAKE_PATH/hosts/$HOSTNAME/"

# 11. create Impermanence directory
persist_dir="$temp/persist/etc/ssh"
mkdir -p "$persist_dir"
cp "$ssh_key_dir/ssh_host_ed25519_key"* "$persist_dir/"
log_info "SSH keys prepared for impermanence setup"

# 12. execute nixos-anywhere
echo
log_info "Ready to deploy! Starting nixos-anywhere..."
log_info "Command: nixos-anywhere --flake ${FLAKE_PATH}#${HOSTNAME} --extra-files $temp ${NIXOS_ANYWHERE_ARGS[*]} $TARGET_HOST"

echo
read -p "Proceed with deployment? (y/N): " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_info "Deployment cancelled by user"
    exit 0
fi

log_info "Executing nixos-anywhere..."
nixos-anywhere \
    --flake "${FLAKE_PATH}#${HOSTNAME}" \
    --extra-files "$temp" \
    "${NIXOS_ANYWHERE_ARGS[@]}" \
    "$TARGET_HOST"

if [ $? -eq 0 ]; then
    log_success "Deployment completed successfully!"
    echo
    log_info "SSH host key fingerprint:"
    ssh-keygen -lf "$ssh_key_dir/ssh_host_ed25519_key.pub"
    echo
    log_info "You can now connect to the server:"
    log_info "ssh ${TARGET_HOST#*@}"
else
    log_error "Deployment failed!"
    exit 1
fi
