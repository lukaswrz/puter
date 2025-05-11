{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop;
in
{
  config = lib.mkIf cfg.enable {
    hardware = {
      bluetooth.enable = true;
      steam-hardware.enable = true;
      xone.enable = true;
      xpadneo.enable = true;
      opentabletdriver.enable = true;
      gcadapter.enable = true;
      graphics.enable = true;
      enableAllFirmware = true;
    };
  };
}
