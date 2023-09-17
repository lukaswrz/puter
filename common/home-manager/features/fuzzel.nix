{config, ...}: {
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        font = "Iosevka Nerd Font";
        terminal = "${config.programs.foot.package}/bin/foot";
        layer = "overlay";
      };
      colors = {
        background = "263238c0";
        text = "ffffffff";
        match = "eeffffff";
        selection = "82aaffdd";
        selection-text = "eeffffff";
        border = "314549fa";
      };
      border = {
        width = 2;
        radius = 5;
      };
    };
  };
}
