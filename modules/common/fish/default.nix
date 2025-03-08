{ pkgs, config, ... }:
{
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
    plugins = [
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair-fish.src;
      }
      {
        name = "hydro";
        src = pkgs.fishPlugins.hydro.src;
      }
    ];
    shellAliases = {
      # # docker
      # d = "docker";
      # dp = "podman";

      # git
      g = "git";
      gl = "git pull --prune";
      glg = "git log --graph --decorate --oneline --abbrev-commit";
      glga = "glg --all";
      gp = "git push origin HEAD";
      gpa = "git push origin --all";
      gd = "git diff";
      gc = "git commit -s";
      gca = "git commit -sa";
      gco = "git checkout";
      gb = "git branch -v";
      ga = "git add";
      gaa = "git add -A";
      gcm = "git commit -sm";
      gcam = "git commit -sam";
      gs = "git status -sb";
      glnext = "git log --oneline (git describe --tags --abbrev=0 @^)..@";
      gw = "git switch";
      gm = "git switch (git main-branch)";
      gms = "git switch (git main-branch); and git sync";
      egms = "e; git switch (git main-branch); and git sync";
      gwc = "git switch -c";
      gpr = "git ppr";

      # # go
      # gmt = "go mod tidy";
      # grm = "go run ./...";

      # tmux
      # ta = "tmux new -A -s default";

      freeze = "freeze -c full";

      # mods
      gcai = "git --no-pager diff | mods 'write a commit message for this patch. also write the long commit message. use semantic commits. break the lines at 80 chars' >.git/gcai; git commit -a -F .git/gcai -e";
    };
    functions = {
      c = builtins.readFile ./functions/c.fish;
      y = builtins.readFile ./functions/y.fish;
      mkc = builtins.readFile ./functions/mkc.fish;
      cdr = builtins.readFile ./functions/cdr.fish;
    };
  };

  xdg.configFile."fish/themes/gruvbox.theme" = {
    source = ./gruvbox-dark.theme;
  };
}
