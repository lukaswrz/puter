{pkgs, ...}: {
  programs.foot = {
    enable = true;

    settings = {
      main = {
        app-id = "foot";
        font = "monospace:size=12";
        initial-window-size-chars = "80x24";
        notify = "notify-send -a \${app-id} -i \${app-id} \${title} \${body}";
      };

      scrollback = {
        lines = 10000;
      };

      url = {
        launch = "${pkgs.xdg-utils}/bin/xdg-open \${url}";
      };

      cursor = {
        style = "block";
        blink = "yes";
      };

      mouse = {
        hide-when-typing = "yes";
      };

      colors = {
        alpha = "0.9";
        foreground = "a9b1d6";
        background = "09090a";
        regular0 = "212121";
        regular1 = "f07178";
        regular2 = "c3e88d";
        regular3 = "ffcb6b";
        regular4 = "82aaff";
        regular5 = "c792ea";
        regular6 = "89ddff";
        regular7 = "eeffff";
        bright0 = "4a4a4a";
        bright1 = "f07178";
        bright2 = "c3e88d";
        bright3 = "ffcb6b";
        bright4 = "82aaff";
        bright5 = "c792ea";
        bright6 = "89ddff";
        bright7 = "ffffff";
      };
    };
  };
}
