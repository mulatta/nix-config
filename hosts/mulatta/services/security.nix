{
  config,
  pkgs,
  lib,
  ...
}: {
  security.pam.u2f = {
    enable = true;
    settings = {
      origin = "pam://nixos";
      cue = true;
      interactive = true;
      authfile = "/etc/u2f-mappings";
    };
  };

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
}
