{ config, lib, ... }:
let
  cfg = config.profiles.headful;
in
{
  options.profiles.headful = {
    enable = lib.mkEnableOption "headful";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.profiles.server.enable;
        message = "The headful profile is not compatible with the server profile.";
      }
    ];
  };
}
