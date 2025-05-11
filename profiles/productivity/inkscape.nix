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
    pkgs.inkscape-with-extensions
  ];
  };
}
