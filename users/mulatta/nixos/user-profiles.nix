{ config, pkgs, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mulatta = {
    isNormalUser = true;
    home = "/home/mulatta";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERkTnc18K6v80qc/LNfzEzQFSu1jbqA7PYuA+ch4Ui9 lsw1167@gmail.com"
    ];
    description = "Seungwon Lee";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };
}
