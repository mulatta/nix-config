{
  pkgs,
  config,
  ...
}: {
  programs.fish = {
    enable = true;
    shellInit = ''
      if test -f ~/.localrc.fish
          source ~/.localrc.fish
      end
    '';
    interactiveShellInit = ''
      # disable fish greeting
      set fish_greeting
      fish_config theme choose gruvbox
      fish_add_path -p ~/.nix-profile/bin /nix/var/nix/profiles/default/bin
      set -a fish_complete_path ~/.nix-profile/share/fish/completions/ ~/.nix-profile/share/fish/vendor_completions.d/
      set hydro_color_pwd brcyan
      set hydro_color_git brmagenta
      set hydro_color_error brred
      set hydro_color_prompt brgreen
      set hydro_color_duration bryellow
      set hydro_multiline true
    '';
  };
}
