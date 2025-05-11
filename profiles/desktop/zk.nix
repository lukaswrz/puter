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
    environment.systemPackages = [
      pkgs.zk
    ];
  };
}
