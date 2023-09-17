{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 500;
        height = 200;
        offset = "20x50";
        origin = "top-right";
        transparency = 10;
        frame_color = "#eceff1";
        font = "monospace 12";
      };

      urgency_normal = {
        background = "#37474f";
        foreground = "#eceff1";
        timeout = 10;
      };
    };
  };
}
