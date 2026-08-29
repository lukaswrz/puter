{ config, lib, ... }:
let
  cfg = config.profiles.server;
in
{
  options.profiles.server = {
    enable = lib.mkEnableOption "server";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.profiles.desktop.enable;
        message = "The server profile is not compatible with the desktop profile.";
      }
    ];

    networking.useNetworkd = true;
    time.timeZone = "UTC";
  };
}
