{pkgs, ...}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "penumbra+";
      editor = {
        lsp.display-messages = true;
        indent-guides.render = true;
        file-picker.hidden = false;
        line-number = "relative";
        bufferline = "multiple";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
      keys.normal = {
        esc = ["collapse_selection" "keep_primary_selection"];
      };
    };
  };
}
