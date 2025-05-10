{
  pkgs,
  config,
  ...
}: {
  imports = [
    # ./sops.nix
    ../common/global
    ./disko.nix
    ./hardware.nix
    ./networking.nix
    ./security.nix
    ./services
    ./tailscale.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  ### ===== USER ACCOUNT =====
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.seungwon = {
    isNormalUser = true;
    description = "Seungwon Lee";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICnNWzmU3xfT6oTe2MVuXs5iAhGv8w9gjCMMguU4VNX+ eq12git-67085791+mulatta@users.noreply.github.com"
    ];
    # packages = with pkgs; [ ];
  };
  programs.zsh.enable = true;

  ### ===== SERVICES =====
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  nix = {
    package = pkgs.nix;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
