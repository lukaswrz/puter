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
      pkgs.kdePackages.plasma-browser-integration
      pkgs.kdePackages.elisa
    ];
  };
}
