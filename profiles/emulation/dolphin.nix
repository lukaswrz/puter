{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.emulation;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.dolphin-emu
    ];
  };
}
