{
  pkgs,
  config,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin isLinux;
  socketPath = (
    if isDarwin
    then "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else if isLinux
    then ""
    else throw "System Not Supported."
  );
in {
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    initContent = ''
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

      proj() {
        local PROJECT_DIR="$HOME/Developer/mulatta"
        local SELECTED_DIR=$(find "$PROJECT_DIR" -maxdepth 1 -type d -exec basename {} \; | sort | gum choose)

        if [ -n "$SELECTED_DIR" ]; then
            cd "$PROJECT_DIR/$SELECTED_DIR"
        fi
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
      d = "delta";
      cat = "bat";
      clamOn = "sudo pmset -b disablesleep 1";
      clamOff = "sudo pmset -b disablesleep 0";
      tt = "taskwarrior-tui";

      # git alias
      gs = "git status";
    };

    sessionVariables = {
      # SSH_AUTH_SOCK = socketPath;
      SSH_AUTH_SOCK = socketPath;
    };
  };
}
