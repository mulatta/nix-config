{pkgs ? import <nixpkgs> {}, ...}: {
  default = pkgs.mkShell {
    name = "config";
    NIX_CONFIG = "extra-experimental-features = nix-command flakes ca-derivations";
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git
      just

      pre-commit-hook-ensure-sops

      # ==== Security modules ====
      openssh
      gnupg
      pinentry-curses
      sops
      rage
      ssh-to-age
      paperkey
      yubikey-personalization
      age-plugin-yubikey
      libfido2
      pam_u2f
      yubico-piv-tool
    ];
    shellHook = ''
    '';
  };
}
