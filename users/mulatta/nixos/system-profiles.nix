{ pkgs, config, ... }:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
  ];
  environment.shells = with pkgs; [ zsh bash ];

  # enable zsh for default shell
  programs.zsh.enable = true;
}
