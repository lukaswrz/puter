{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.productivity;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.gimp3-with-plugins
    ];
  };
}
