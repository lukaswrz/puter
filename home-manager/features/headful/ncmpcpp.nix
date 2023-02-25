{
  programs.ncmpcpp = {
    enable = true;

    settings = {
      system_encoding = "utf-8";

      incremental_seeking = "yes";
      seek_time = "1";

      user_interface = "classic";

      colors_enabled = "yes";
      header_window_color = "blue";
      volume_color = "blue";
      state_line_color = "green";
      state_flags_color = "red";
      main_window_color = "blue";
      color1 = "red";
      color2 = "magenta";
      progressbar_color = "blue";
      statusbar_color = "default";
      alternative_ui_separator_color = "green";
      visualizer_color = "blue";
      window_border_color = "magenta";
      active_window_border = "blue";
    };

    bindings = [
      {
        key = "/";
        command = "find";
      }
      {
        key = "/";
        command = "find_item_forward";
      }
      {
        key = "t";
        command = "find";
      }
      {
        key = "t";
        command = "find_item_forward";
      }

      {
        key = "+";
        command = "show_clock";
      }
      {
        key = "=";
        command = "volume_up";
      }

      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "k";
        command = "scroll_up";
      }

      {
        key = "ctrl-u";
        command = "page_up";
      }

      {
        key = "ctrl-d";
        command = "page_down";
      }

      {
        key = "h";
        command = "previous_column";
      }
      {
        key = "l";
        command = "next_column";
      }

      {
        key = ".";
        command = "show_lyrics";
      }

      {
        key = "n";
        command = "next_found_item";
      }
      {
        key = "N";
        command = "previous_found_item";
      }

      {
        key = "J";
        command = "move_sort_order_down";
      }
      {
        key = "K";
        command = "move_sort_order_up";
      }

      {
        key = "g";
        command = "move_home";
      }

      {
        key = "G";
        command = "move_end";
      }

      {
        key = "0";
        command = "replay_song";
      }
      {
        key = "ctrl-f";
        command = "page_down";
      }
      {
        key = "ctrl-b";
        command = "page_up";
      }
    ];
  };
}
