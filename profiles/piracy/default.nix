{ config, lib, ... }:
let
  cfg = config.profiles.piracy;
in
{
  options.profiles.piracy = {
    enable = lib.mkEnableOption "piracy";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.profiles.desktop.enable;
        message = "The piracy profile depends on the desktop profile.";
      }
    ];
  };
}
