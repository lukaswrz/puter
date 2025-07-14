{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop;
in
{
  config = lib.mkIf cfg.enable {
    services = {
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };

      desktopManager.plasma6.enable = true;
    };
  };
}
