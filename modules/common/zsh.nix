{ config, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    initExtra = ''
      _fzf_comprun() {
        local command=$1
        shift
        case "$command" in
          cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
          export|unset) fzf --preview "eval 'echo \$\{}'" "$@" ;;
          ssh)          fzf --preview 'dig {}' "$@" ;;
          *)           fzf --preview "if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi" "$@" ;;
        esac
      }

      _fzf_compgen_path() {
        fd --hidden --exclude .git . "$1"
      }

      _fzf_compgen_dir() {
        fd --type=d --hidden --exclude .git . "$1"
      }
    '';

    autosuggestion = {
      enable = true;
      highlight = "fg = #ff00ff,bg=cyan,underline,bold";
    };

    syntaxHighlighting.enable = true;

    history = {
      path = "${config.xdg.configHome}/zsh/zhistory";
      save = 10000;
      size = 10000;
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
      share = true;
    };

    # shell aliases
    shellAliases = {
      cat = "bat";
    };
  };
}
