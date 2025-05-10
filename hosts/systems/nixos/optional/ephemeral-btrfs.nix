# This file contains an ephemeral btrfs root configuration with disko integration
{
  lib,
  config,
  ...
}: let
  # Extract device information from disko configuration if available
  diskoMainDevice =
    lib.findFirst
    (device: device.content.type == "gpt")
    null
    (lib.attrValues (config.disko.devices.disk or {}));

  # Determine the device path either from disko config or use hostname as fallback
  devicePath =
    if diskoMainDevice != null
    then diskoMainDevice.device # Use device path from disko configuration
    else "/dev/disk/by-label/${config.networking.hostName}"; # Fallback to hostname label

  # The main partition containing our Btrfs filesystem (taygeta or similar)
  btrfsPartition =
    if diskoMainDevice != null
    then
      lib.findFirst
      (part: part.content.type == "btrfs")
      null
      (lib.attrValues diskoMainDevice.content.partitions)
    else null;

  # Device label can be extracted from disko config or use hostname as fallback
  deviceLabel =
    if btrfsPartition != null && btrfsPartition.content.extraArgs != null
    then builtins.elemAt btrfsPartition.content.extraArgs 1 # Extract label from extraArgs
    else config.networking.hostName; # Fallback to hostname

  # Script to wipe and restore the root filesystem from the blank snapshot
  wipeScript = ''
    mkdir /tmp -p
    MNTPOINT=$(mktemp -d)
    (
      mount -t btrfs -o subvol=/ ${devicePath} "$MNTPOINT"
      trap 'umount "$MNTPOINT"' EXIT

      echo "Creating needed directories"
      mkdir -p "$MNTPOINT"/persist/var/{log,lib/{nixos,systemd}}
      if [ -e "$MNTPOINT/persist/dont-wipe" ]; then
        echo "Skipping wipe"
      else
        echo "Cleaning root subvolume"
        btrfs subvolume list -o "$MNTPOINT/root" | cut -f9 -d ' ' | sort |
        while read -r subvolume; do
          btrfs subvolume delete "$MNTPOINT/$subvolume"
        done && btrfs subvolume delete "$MNTPOINT/root"

        echo "Restoring blank subvolume"
        btrfs subvolume snapshot "$MNTPOINT/root-blank" "$MNTPOINT/root"
      fi
    )
  '';
  phase1Systemd = config.boot.initrd.systemd.enable;
in {
  boot.initrd = {
    supportedFilesystems = ["btrfs"];
    postDeviceCommands = lib.mkIf (!phase1Systemd) (lib.mkBefore wipeScript);
    systemd.services.restore-root = lib.mkIf phase1Systemd {
      description = "Rollback btrfs rootfs";
      wantedBy = ["initrd.target"];
      requires = ["dev-disk-by\\x2dlabel-${deviceLabel}.device"];
      after = [
        "dev-disk-by\\x2dlabel-${deviceLabel}.device"
        "systemd-cryptsetup@${deviceLabel}.service"
      ];
      before = ["sysroot.mount"];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = wipeScript;
    };
  };

  fileSystems = {
    "/" = lib.mkDefault {
      device = devicePath;
      fsType = "btrfs";
      options = [
        "subvol=root"
        "compress=zstd"
      ];
    };

    "/nix" = lib.mkDefault {
      device = devicePath;
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "noatime"
        "compress=zstd"
      ];
    };

    "/persist" = lib.mkDefault {
      device = devicePath;
      fsType = "btrfs";
      options = [
        "subvol=persist"
        "compress=zstd"
      ];
      neededForBoot = true;
    };

    "/swap" = lib.mkDefault {
      device = devicePath;
      fsType = "btrfs";
      options = [
        "subvol=swap"
        "noatime"
      ];
    };
  };
}
