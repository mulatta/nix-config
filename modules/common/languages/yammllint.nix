{ config, pkgs,... }:
{
  config.xdg.configFile."yamllint/config".text = ''
    extends: relaxed
    rules:
      line-length: disable
  '';
}
