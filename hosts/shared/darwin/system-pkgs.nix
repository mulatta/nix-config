{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    custom-scripts
    nodejs_23
    python312Full
    yubikey-manager
    pam_u2f
  ];
}
