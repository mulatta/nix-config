{pkgs, ...}: {
  services.yubikey-agent = {
    enable = true;
    package = pkgs.yubikey-agent;
  };
  home.packages = with pkgs; [
    yubikey-manager
    yubikey-personalization
    age-plugin-yubikey
    libfido2
    pam_u2f
    yubico-piv-tool
  ];
}
