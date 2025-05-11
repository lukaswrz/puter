{ config, lib, ... }:
let
  cfg = config.profiles.emulation;
in
{
  options.profiles.emulation = {
    enable = lib.mkEnableOption "emulation";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.profiles.desktop.enable;
        message = "The emulation profile depends on the desktop profile.";
      }
    ];
  };
}
