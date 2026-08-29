{ config, lib, ... }:
let
  cfg = config.profiles.dynamic;
in
{
  options.profiles.dynamic = {
    enable = lib.mkEnableOption "dynamic";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.profiles.server.enable;
        message = "The dynamic profile is not compatible with the server profile.";
      }
    ];

    location.provider = "geoclue2";

    networking.networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };

    services.resolved.enable = true;

    users.groups.networkmanager.members = config.users.normalUsers;
  };
}
