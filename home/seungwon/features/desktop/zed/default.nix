{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;
    userSettings = {
      feature = {
        copilot = true;
      };
      ui_font_size = 16;
      buffer_font_size = 16;
      vim_mode = true;
      vim = {
        "default_mode" = "helix";
      };
    };
    extensions = ["nix"];
  };
}
