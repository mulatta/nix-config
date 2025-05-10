{
  homebrew = {
    enable = true;
    brews = [
      "mas"
      "fontconfig"
      "tailscale"
    ];
    casks = [
      "1password"
      "akiflow"
      "aldente"
      "alfred"
      "bookends"
      "claude"
      "cleanshot"
      "docker"
      "devonthink"
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
      "yubico-yubikey-manager"
      "zen"
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
