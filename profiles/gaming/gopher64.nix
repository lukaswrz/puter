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
    # environment.systemPackages = [ pkgs.gopher64 ];
  };
}
