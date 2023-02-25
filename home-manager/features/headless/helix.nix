{
  programs.helix = {
    enable = true;
    languages = [ ];
    settings = {
      theme = "monokai";
      editor = {
        lsp.display-messages = true;
        indent-guides.render = true;
        file-picker.hidden = false;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
    };
  };
}
