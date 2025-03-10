{
  homebrew = {
    enable = true;
    brews = [
      "mas"
      "fontconfig"
    ];
    casks = [
      "akiflow"
      "obsidian"
      "hammerspoon"
      "firefox"
      "alfred"
      "hazel"
      "bookends"
      "cleanshot"
      "hancom-word"
      "logi-options+"
      "league-of-legends"
      "claude"
      "ghostty"
    ];
    masApps = {
      "KakaoTalk" = 869223134;
      "Microsoft PowerPoint" = 462062816;
      "Microsoft Excel" = 462058435;
      "Microsoft Word" = 462054704;
      "Onedrive" = 823766827;
      "ZSA Keymapp" = 6472865291;
      "Tailscale" = 1475387142;
    };
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
