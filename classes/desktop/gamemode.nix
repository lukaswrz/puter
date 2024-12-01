{
  lib,
  pkgs,
  ...
}: {
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
}
