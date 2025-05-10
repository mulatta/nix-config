{
  homebrew = {
    enable = true;
    brews = [
      "mas"
      "fontconfig"
    ];
    casks = [
      "1password"
      "akiflow"
      "aldente"
      "alfred"
      "bookends"
      "claude"
      "cleanshot"
      "ghostty"
      "hancom-word"
      "hazel"
      "homerow"
      "hookmark"
      "imagej"
      "karabiner-elements"
      "keycastr"
      "keymapp"
      "league-of-legends"
      "logi-options+"
      "raindropio"
      "raycast"
      "slack"
      "zen-browser"
      "zoom"
      "zotero"
    ];
    masApps = {
      "KakaoTalk" = 869223134;
      "Microsoft PowerPoint" = 462062816;
      "Microsoft Excel" = 462058435;
      "Microsoft Word" = 462054704;
      "Tailscale" = 1475387142;
    };
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
