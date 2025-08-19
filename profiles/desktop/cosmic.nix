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
      desktopManager.cosmic.enable = true;
      displayManager.cosmic-greeter.enable = true;
    };

    environment.cosmic.excludePackages = [
      pkgs.cosmic-edit
      pkgs.cosmic-player
    ];

    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
  };
}
