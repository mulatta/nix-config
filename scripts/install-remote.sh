#!/usr/bin/env bash
set -euo pipefail

# Check if target and disk arguments are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <target_host> <disk_device> [hostname]"
    echo "Example: $0 root@192.168.1.100 /dev/sda mulatta"
    exit 1
fi

TARGET="$1"
DISK_DEVICE="$2"
HOSTNAME="${3:-mulatta}"  # Default to mulatta if not specified

# Update disk device in the disko configuration
TEMP_CONFIG=$(mktemp)
cat hosts/$HOSTNAME/disko-config.nix | sed "s|device = \"/dev/sda\"|device = \"$DISK_DEVICE\"|" > "$TEMP_CONFIG"
cp "$TEMP_CONFIG" hosts/$HOSTNAME/disko-config.nix
rm "$TEMP_CONFIG"

# Run NixOS Anywhere installation
nix run github:nix-community/nixos-anywhere -- \
  --flake .#$HOSTNAME \
  --disk-device "$DISK_DEVICE" \
  "$TARGET"

echo "Installation complete! The system will reboot and be available at the configured IP address." 