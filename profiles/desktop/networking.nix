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
    services.resolved.enable = true;

    networking.networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };

    users.groups.networkmanager.members = config.users.normalUsers;
  };
}
