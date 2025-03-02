{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ aldente ];
  launchd.agents.aldente = {
    enable = true;
    config = {
      Label = "com.apphousekitchen.aldente-pro";
      ProgramArguments = [
        "${pkgs.aldente}/Applications/AlDente.app/Contents/MacOS/AlDente"
      ];
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}

