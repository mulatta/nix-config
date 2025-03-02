{
  theme = "nightfox";
  editor = {
    line-number = "relative";
    mouse = false;
    bufferline = "always";
    lsp.display-messages = true;
    cursor-shape = {
      insert = "bar";
      normal = "block";
      select = "underline";
    };
    statusline = {
      left = [ "mode" "spinner" "file-base-name" ];
      right = [ "diagnostics" "selections" "position" "file-encoding" ];
    };
  };
  keys.normal.space = {
    space = "file_picker";
    w = ":w";
    q = ":q";
    Q = ":q!";
    n = ":n";
  };
  keys.normal = {
    "A-j" = [ "extend_to_line_bounds" "delete_selection" "paste_after" ];
    "A-k" = [ "extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before" ];
    esc = [ "collapse_selection" "keep_primary_selection" ];
  };
  keys.normal.C-y = {
    # Open the file(s) in the current window
    y = ":sh zellij run -c -f -x 10% -y 10% --width 80% --height 80% -- bash ~/.config/helix/yazi-picker.sh open";
    # Open the file(s) in a vertical pane
    v = ":sh zellij run -c -f -x 10% -y 10% --width 80% --height 80% -- bash ~/.config/helix/yazi-picker.sh vsplit";
    # Open the file(s) in a horizontal pane
    h = ":sh zellij run -c -f -x 10% -y 10% --width 80% --height 80% -- bash ~/.config/helix/yazi-picker.sh hsplit";

  };
}
