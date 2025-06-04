{pkgs, ...}: {
  home.packages = with pkgs; [
    sops
    rage
    ssh-to-age
    yubikey-manager
    pam_u2f
  ];
}
