{
  programs.i3status-rust = {
    enable = true;

    bars = {
      default = {
        icons = "material-nf";

        settings = {
          theme.overrides = {
            idle_bg = "#0e0e0ef0";
            idle_fg = "#c5c8c6";
            info_bg = "#3971ed";
            info_fg = "#0e0e0ef0";
            good_bg = "#198844";
            good_fg = "#0e0e0ef0";
            warning_bg = "#fba922";
            warning_fg = "#0e0e0ef0";
            critical_bg = "#cc342b";
            critical_fg = "#0e0e0ef0";
            separator = "";
            separator_bg = "auto";
            separator_fg = "auto";
          };
        };

        blocks = [
          {
            block = "focused_window";
            max_width = 100;
            show_marks = "visible";
            format = "{combo}";
          }
          {
            block = "net";
            format = "{ssid} {signal_strength} {speed_up;M*b} {speed_down;M*b}";
            interval = 1;
          }
          {
            block = "memory";
            display_type = "memory";
            format_mem = "{mem_used} ({mem_used_percents:1})";
            format_swap = "{swap_used_percents}%";
          }
          {
            block = "cpu";
            interval = 5;
            format = "{barchart}";
          }
          {
            block = "disk_space";
            path = "/";
            alias = "/";
            info_type = "available";
            unit = "GB";
            interval = 60;
            warning = 20.0;
            alert = 10.0;
          }
          {
            block = "battery";
            interval = 10;
            format = "{percentage}";
            hide_missing = true;
            device = "BAT0";
          }
          {
            block = "battery";
            interval = 10;
            format = "{percentage}";
            hide_missing = true;
            device = "BAT1";
          }
          {
            block = "sound";
            format = "{volume}";
            device_kind = "sink";
          }
          {
            block = "sound";
            format = "{volume}";
            device_kind = "source";
          }
          {
            block = "music";
            buttons = [ "prev" "play" "next" ];
            max_width = 10;
            hide_when_empty = true;
          }
          {
            block = "time";
            interval = 1;
            format = "%H:%M:%S, %d. %b";
          }
        ];
      };
    };
  };
}
