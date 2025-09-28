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

    environment = {
      systemPackages = [
        pkgs.kdePackages.sddm-kcm
      ];

      plasma6.excludePackages = [
        pkgs.kdePackages.elisa
      ];
    };
  };
}
