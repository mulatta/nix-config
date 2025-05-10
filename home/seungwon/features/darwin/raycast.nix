{pkgs, ...}: {
  home.packages = with pkgs; [
    raycast
  ];
  # services.raycast = {
  #   enable = true;
  #   config = {
  #     navigationCommandStyleIdentifierKey = "vim";
  #     raycastGlobalHotkey = "Command-49";
  #     raycastPreferredWindowMode = "compact";
  #   };
  # };
}
