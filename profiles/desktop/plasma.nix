{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.desktop;
in
{
  config = lib.mkIf cfg.enable {
    services = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
      gnome.core-apps.enable = true;
    };

    environment = {
      gnome.excludePackages = [
        pkgs.epiphany
        pkgs.gnome-music
        pkgs.loupe
        pkgs.simple-scan
        pkgs.snapshot
        pkgs.yelp
      ];

      systemPackages = [
        pkgs.gnomeExtensions.appindicator
      ];
    };
  };
}
