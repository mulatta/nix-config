final: prev: {
  customScripts = {
    commit = prev.writeShellScriptBin "gcm" (builtins.readFile ./commit.sh);
    git-stage = prev.writeShellScriptBin "gst" (builtins.readFile ./git-stage.sh);
    git-branch-manager = prev.writeShellScriptBin "gbm" (builtins.readFile ./git-branch-manager.sh);
    convert-to-gif = prev.writeShellScriptBin "tgif" (builtins.readFile ./convert-to-gif.sh);
    dev-template = prev.writeShellScriptBin "dvt" (builtins.readFile ./dev-template.sh);
    meal = prev.writeShellScriptBin "meal" ''
      export PATH="${prev.htmlq}/bin:$PATH"
      ${builtins.readFile ./meal.sh}
    '';
  };

  custom-scripts = prev.symlinkJoin {
    name = "custom-scripts";
    paths = with final.customScripts; [
      commit
      git-stage
      git-branch-manager
      convert-to-gif
      meal
      dev-template
    ];
  };
}
