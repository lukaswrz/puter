{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.dynamic;
in
{
  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;

    users.groups.networkmanager.members = config.users.normalUsers;
  };
}
