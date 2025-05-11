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
  # TODO
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.vesktop
    ];
  };
}
