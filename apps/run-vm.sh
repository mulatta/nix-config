#!/usr/bin/env bash
set -e

# 사용법 출력
if [ $# -lt 1 ]; then
  echo "Usage: run-vm <vm-name> [qemu-options]"
  echo "Examples:"
  echo "  run-vm vm-test"
  echo "  run-vm vm-test -m 8192 -smp 4"
  echo ""
  echo "Available VMs:"
  echo "  $(nix flake show --json 2>/dev/null | jq -r '.nixosConfigurations | keys[]' 2>/dev/null || echo "Error listing VMs")"
  exit 1
fi

VM_NAME="$1"
shift

# VM 설정 존재 확인
if ! nix flake show --json | jq -e ".nixosConfigurations.\"$VM_NAME\"" > /dev/null; then
  echo "Error: VM configuration '$VM_NAME' not found"
  exit 1
fi

# VM 빌드 및 실행
echo "Building VM: $VM_NAME..."
VM_PATH="$(nix build ".#nixosConfigurations.$VM_NAME.config.system.build.vm" --no-link --print-out-paths)"

if [ -n "$VM_PATH" ]; then
  echo "Starting VM: $VM_NAME"
  
  # QEMU 옵션 설정
  if [ $# -gt 0 ]; then
    echo "Additional QEMU options: $@"
    export QEMU_OPTS="$@"
  fi
  
  # VM 실행
  "$VM_PATH/bin/run-nixos-vm"
else
  echo "Error: Failed to build VM"
  exit 1
fi
