{
  programs.i3status-rust = {
    enable = true;

    bars = {
      default = {
        icons = "material-nf";

        settings = {
          theme.overrides = {
            idle_bg = "#000000";
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
            format = "{ $title $visible_marks |}";
          }
          {
            block = "net";
            format = " $icon ^icon_net_up $speed_up ^icon_net_down $speed_down ";
            interval = 1;
          }
          {
            block = "memory";
            format = " $icon $mem_used ";
            interval = 5;
          }
          {
            block = "cpu";
            format = " $icon $barchart ";
            interval = 5;
          }
          {
            block = "disk_space";
            path = "/home";
            info_type = "available";
            alert_unit = "GB";
            alert = 10;
            warning = 15;
            format = " $icon $used/$total ";
          }
          {
            block = "battery";
            interval = 10;
            format = " $icon $percentage ";
            missing_format = "";
            device = "BAT0";
          }
          {
            block = "battery";
            interval = 10;
            format = " $icon $percentage {$time |}";
            missing_format = "";
            device = "BAT1";
          }
          {
            block = "sound";
            format = " $icon {$volume |}";
            device_kind = "sink";
          }
          {
            block = "sound";
            format = " $icon {$volume |}";
            device_kind = "source";
          }
          {
            block = "music";
            format = "{ $icon $combo $prev $play $next |}";
          }
          {
            block = "time";
            interval = 1;
            format = " $icon $timestamp.datetime(f:'%H:%M:%S, %b %d.') ";
          }
        ];
      };
    };
  };
}
