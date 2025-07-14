{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.profiles.desktop;
in
{
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

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
