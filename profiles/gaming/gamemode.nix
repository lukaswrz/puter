{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.gaming;
in
{
  config = lib.mkIf cfg.enable {
    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
        };
        custom = {
          start = "${lib.getExe pkgs.libnotify} 'GameMode started'";
          end = "${lib.getExe pkgs.libnotify} 'GameMode stopped'";
        };
      };
    };

    users.groups.gamemode.members = config.users.normalUsers;
  };
}
