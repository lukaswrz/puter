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
      desktopManager.plasma6.enable = true;
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    environment.plasma6.excludePackages = [
      pkgs.kdePackages.elisa
    ];

    specialisation.cosmic.configuration = {
      services = {
        desktopManager.plasma6.enable = lib.mkForce false;
        displayManager.sddm.enable = lib.mkForce false;
        desktopManager.cosmic.enable = true;
        displayManager.cosmic-greeter.enable = true;
      };

      environment.cosmic.excludePackages = [
        pkgs.cosmic-edit
        pkgs.cosmic-player
      ];
    };

    specialisation.gnome.configuration = {
      services = {
        desktopManager.plasma6.enable = lib.mkForce false;
        displayManager.sddm.enable = lib.mkForce false;
        desktopManager.gnome.enable = true;
        displayManager.gdm.enable = true;
      };

      services.gnome.core-apps.enable = true;

      environment.gnome.excludePackages = [
        pkgs.epiphany
        pkgs.gnome-music
        pkgs.loupe
        pkgs.simple-scan
        pkgs.snapshot
        pkgs.yelp
      ];

      environment.systemPackages = [
        pkgs.gnomeExtensions.appindicator
      ];
    };
  };
}
