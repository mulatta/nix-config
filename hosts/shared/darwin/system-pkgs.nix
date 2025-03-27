{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nodejs23
  ];
}
