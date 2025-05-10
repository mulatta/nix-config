{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    ../systems/nixos/optional/ephemeral-btrfs.nix
  ];

  nixpkgs.hostPlatform.system = "x86_64-linux";

  # ======== Boot Options ========
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    # kernelModules = ["kvm-intel"];
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "i686-linux"
    ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules = ["ata_piix" "uhci_hcd"];
  };

  # ======== File System ========
  disko.devices.disk.main = {
    device = "/dev/nvme0n1";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          size = "1M";
          type = "EF02";
        };
        esp = {
          name = "ESP";
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        main = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = ["-L${config.networking.hostName}"];
            postCreateHook = ''
              MNTPOINT=$(mktemp -d)
              mount -t btrfs "${config.disko.devices.disk.main.content.partitions.main.device}" "$MNTPOINT"
              trap 'umount $MNTPOINT; rm -d $MNTPOINT' EXIT
              btrfs subvolume snapshot -r "$MNTPOINT/root" "$MNTPOINT/root-blank"
            '';
            subvolumes = {
              "/root" = {
                mountOptions = ["compress=zstd"];
                mountpoint = "/";
              };
              "/nix" = {
                mountOptions = ["compress=zstd" "noatime"];
                mountpoint = "/nix";
              };
              "/persist" = {
                mountOptions = ["compress=zstd" "noatime"];
                mountpoint = "/persist";
              };
              "/swap" = {
                mountOptions = ["compress=zstd" "noatime"];
                mountpoint = "/swap";
                swap.swapfile = {
                  size = "8196M";
                  path = "swapfile";
                };
              };
            };
          };
        };
      };
    };
  };
  fileSystems."/persist".neededForBoot = true;
}
