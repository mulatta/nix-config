{ pkgs, config, ... }:
{
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    silent = true;
    stdlib = ''
      export_function() {
        local name=$1
        local alias_dir=${config.xdg.configHome}/.direnv/aliases
        mkdir -p "$alias_dir"
        PATH_add "$alias_dir"
        local target="$alias_dir/$name"
        if declare -f "$name" >/dev/null; then
          echo "#!/usr/bin/env bash" > "$target"
          declare -f "$name" >> "$target" 2>/dev/null
          echo "$name \"\$@\"" >> "$target"
          chmod +x "$target"
        fi
      }
    '';
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
    config = {
      global = {
        load_dotenv = true;
        hide_env_diff = true;
        log_format = "$(tput setaf 1)%e$(tput sgr0)";
      };
    };
  };
}
