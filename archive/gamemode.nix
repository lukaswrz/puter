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
    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
        };
        custom =
          let
            notifyCommand =
              message:
              lib.escapeShellArgs (
                [ (lib.getExe pkgs.libnotify) ]
                ++ (lib.cli.toCommandLineGNU { } {
                  transient = true;
                  urgency = "low";
                  app-name = "GameMode";
                })
                ++ [
                  "--"
                  message
                ]
              );
          in
          {
            start = notifyCommand "GameMode started";
            end = notifyCommand "GameMode stopped";
          };
      };
    };

    users.groups.gamemode.members = config.users.normalUsers;
  };
}
