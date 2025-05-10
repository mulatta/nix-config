{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.cleanshot
  ];
  launchd.agents.cleanshot = {
    enable = true;
    config = {
      Label = "pl.maketheweb.cleanshotx";
      ProgramArguments = [
        "${pkgs.cleanshot}/Applications/CleanShot X.app/Contents/MacOS/CleanShot X"
      ];
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}
