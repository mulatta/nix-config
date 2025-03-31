{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nodejs_23
    commit
    yubikey-manager
    pam_u2f
  ];
}
