{ config, pkgs, ... }:
{

  nix.settings.trusted-users = [
    "root"
    "seungwon"
  ];

  system.defaults.dock = {
    persistent-apps = [
      "/System/Applications/Calendar.app"
      "/System/Applications/Reminders.app"
      "/System/Applications/Messages.app"
      "/System/Applications/Mail.app"
      "/System/Applications/System Settings.app"
      "/Applications/Zen.app"
      "/Applications/Akiflow.app"
      "/Applications/Claude.app"
      "/Applications/Slack.app"
      "${pkgs.wezterm}/Applications/WezTerm.app"
      "/Applications/Ghostty.app"
      "/Applications/KakaoTalk.app"
    ];
  };
}
