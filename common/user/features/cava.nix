{pkgs, ...}: {
  home.packages = with pkgs; [
    cava
  ];

  xdg.configFile."cava/config".text = ''
    [input]
    method = pulse
    source = auto

    [output]
    method = ncurses
  '';
}
