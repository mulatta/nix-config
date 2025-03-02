{ pkgs, config, ... }:
{
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = 5;

  # scripts that make aliases for applications in /Applications
  system.activationScripts.applications.text =
    let
      sysEnv = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = "/Applications";
      };
      userEnv = pkgs.buildEnv {
        name = "user-applications";
        paths = config.home-manager.users.seungwon.home.packages;
        pathsToLink = "/Applications";
      };
    in
    pkgs.lib.mkForce ''
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
    
      find ${sysEnv}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying system app $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    
      find ${userEnv}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying user app $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';

  # ===== For System Packages Only =====
  # system.activationScripts.applications.text =
  #   let
  #     env = pkgs.buildEnv {
  #       name = "system-applications";
  #       paths = config.environment.systemPackages;
  #       pathsToLink = "/Applications";
  #     };
  #   in
  #   pkgs.lib.mkForce ''
  #     echo "setting up /Applications..." >&2
  #     rm -rf /Applications/Nix\ Apps
  #     mkdir -p /Applications/Nix\ Apps
  #     find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
  #     while read -r src; do
  #       app_name=$(basename "$src")
  #       echo "copying $src" >&2
  #       ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
  #     done
  #   '';

  # base settings
  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.1;
      autohide-time-modifier = 0.6;
      show-recents = false;
      wvous-br-corner = 14;
      wvous-tr-corner = 12;
      wvous-tl-corner = 11;
    };

    controlcenter = {
      BatteryShowPercentage = true;
      Bluetooth = true;
    };

    loginwindow.GuestEnabled = false;

    finder = {
      FXPreferredViewStyle = "clmv";
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXSortFoldersFirst = true;
      _FXSortFoldersFirstOnDesktop = true;
      NewWindowTarget = "Home";
    };

    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      KeyRepeat = 2;
      AppleShowAllExtensions = true;
      NSTableViewDefaultSizeMode = 2;
      AppleShowScrollBars = "Always";
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
    };

  };

  # All the private settings like
  # `trusted-users`, `substituters`, etc.
  # should be managed in each user-specific configurations

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };

    optimise.automatic = true;

    gc = {
      automatic = true;
      interval = { Day = 7; };
    };
  };

}
