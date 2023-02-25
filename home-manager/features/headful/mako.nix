{
  programs.mako = {
    enable = true;

    layer = "overlay";
    anchor = "bottom-right";
    borderRadius = 5;
    defaultTimeout = 5000;
    backgroundColor = "#0c0d0e";
    borderColor = "#2e2f30";
    textColor = "#dadbdc";
    font = "monospace 12";
    width = 500;
    height = 200;
    maxIconSize = 256;
    maxVisible = 12;
    sort = "-time";
    # iconPath = "${homeIcons}:${systemIcons}:${homePixmaps}:${systemPixmaps}";
    # icons = true;
  };
}
