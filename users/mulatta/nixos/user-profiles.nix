{ config, pkgs, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mulatta = {
    isNormalUser = true;
    home = "/home/mulatta";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWQb3yhIHdSysbPMXkRNTvAaS6EHhvbwoPkzrL89lbd eq12-server 67085791+mulatta@users.noreply.github.com"
    ];
    description = "Seungwon Lee";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };
}
