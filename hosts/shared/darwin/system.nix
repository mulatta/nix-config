{ pkgs, config, ... }:
{
  system = {
    defaults = {
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

      CustomUserPreferences = {
        "com.apple.NetworkBrowser" = {
          BrowseAllInterfaces = true;
        };
        "com.apple.screensaver" = {
          askForPassword = true;
          askForPasswordDelay = 0;
        };
        "com.apple.trackpad" = {
          scaling = 2;
        };
        "com.apple.mouse" = {
          scaling = 2.5;
        };
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = false;
        };
        "com.apple.LaunchServices" = {
          LSQuarantine = true;
        };
        "com.apple.finder" = {
          ShowExternalHardDrivesOnDesktop = false;
          ShowRemovableMediaOnDesktop = false;
          WarnOnEmptyTrash = false;
        };
        "NSGlobalDomain" = {
          NSNavPanelExpandedStateForSaveMode = true;
          NSTableViewDefaultSizeMode = 1;
          WebKitDeveloperExtras = true;
        };
        "com.apple.ImageCapture" = {
          "disableHotPlug" = true;
        };
        # "com.apple.mail" = {
        #   DisableReplyAnimations = true;
        #   DisableSendAnimations = true;
        #   DisableInlineAttachmentViewing = true;
        #   AddressesIncludeNameOnPasteboard = true;
        #   InboxViewerAttributes = {
        #     DisplayInThreadedMode = "yes";
        #     SortedDescending = "yes";
        #     SortOrder = "received-date";
        #   };
        #   NSUserKeyEquivalents = {
        #     Send = "@\U21a9";
        #     Archive = "@$e";
        #   };
        # };
        "com.apple.dock" = {
          size-immutable = true;
        };
      };
    };

    # scripts that make aliases for applications in /Applications
    # scripts that make aliases for applications in /Applications
    activationScripts.applications.text =
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
        # Application management script
        appManagerScript = pkgs.writeScript "create-nix-app-aliases" ''
          #!/bin/bash
          set -e

          echo "Setting up Nix application aliases..." >&2

          # Create Nix Apps directory if it doesn't exist
          [ ! -d "/Applications/Nix Apps" ] && mkdir -p "/Applications/Nix Apps"

          # Install system apps
          echo "Creating aliases for system applications..." >&2
          find ${sysEnv}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read -r src; do
            app_name=$(basename "$src")
            echo "Creating alias for system app: $app_name" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done

          # Install user apps
          echo "Creating aliases for user applications..." >&2
          find ${userEnv}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read -r src; do
            app_name=$(basename "$src")
            echo "Creating alias for user app: $app_name" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done

          echo "Application alias setup completed successfully" >&2
        '';
      in
      pkgs.lib.mkForce ''
        # Run app management script
        ${appManagerScript}
      '';
  };
}
