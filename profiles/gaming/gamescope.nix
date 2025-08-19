{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.gaming;
in
{
  config = lib.mkIf cfg.enable {
    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
}
