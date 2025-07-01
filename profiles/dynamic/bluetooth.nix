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
    hardware.bluetooth.enable = true;
  };
}
