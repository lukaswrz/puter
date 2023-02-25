{
  programs.zellij = {
    enable = true;

    settings = {
      on_force_close = "detach";

      simplified_ui = true;

      pane_frames = true;

      themes = {
        tokyo-night = {
          fg = [ 169 177 214 ];
          bg = [ 26 27 38 ];
          black = [ 56 62 90 ];
          red = [ 249 51 87 ];
          green = [ 158 206 106 ];
          yellow = [ 224 175 104 ];
          blue = [ 122 162 247 ];
          magenta = [ 187 154 247 ];
          cyan = [ 42 195 222 ];
          white = [ 192 202 245 ];
          orange = [ 255 158 100 ];
        };
        tokyo-night-storm = {
          fg = [ 169 177 214 ];
          bg = [ 36 40 59 ];
          black = [ 56 62 90 ];
          red = [ 249 51 87 ];
          green = [ 158 206 106 ];
          yellow = [ 224 175 104 ];
          blue = [ 122 162 247 ];
          magenta = [ 187 154 247 ];
          cyan = [ 42 195 222 ];
          white = [ 192 202 245 ];
          orange = [ 255 158 100 ];
        };
        tokyo-night-light = {
          fg = [ 52 59 88 ];
          bg = [ 213 214 219 ];
          black = [ 15 15 20 ];
          red = [ 186 75 96 ];
          green = [ 72 94 48 ];
          yellow = [ 143 94 21 ];
          blue = [ 52 84 138 ];
          magenta = [ 90 74 120 ];
          cyan = [ 15 75 110 ];
          white = [ 130 137 172 ];
          orange = [ 150 80 39 ];
        };
      };

      theme = "tokyo-night";

      mouse_mode = true;

      scroll_buffer_size = 10000;

      copy_clipboard = "system";
    };
  };
}
