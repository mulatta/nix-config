{ config, pkgs, ... }:
{

  nix.settings.trusted-users = [ "root" "seungwon" ];

  system.defaults.dock = {
    persistent-apps = [
      "/System/Applications/Calendar.app"
      "/System/Applications/Reminders.app"
      "/System/Applications/Messages.app"
      "/System/Applications/Mail.app"
      "/System/Applications/System Settings.app"
      "/Applications/Firefox.app"
      # "${pkgs.vscode}/Applications/Visual Studio Code.app"
      "${pkgs.slack}/Applications/Slack.app"
      "${pkgs.wezterm}/Applications/WezTerm.app"
      "/Applications/KakaoTalk.app"
    ];
  };
}
