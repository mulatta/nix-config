{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableTransience = true;
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };
}
