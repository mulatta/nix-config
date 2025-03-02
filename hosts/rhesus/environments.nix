{ config, pkgs, ... }:
{
  # System profile 
  environment = {
    systemPackages = with pkgs; [
    ];
    variables = {
      "VAULT" = "$HOME/Research";
    };
  };
}
