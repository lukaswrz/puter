{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.gcadapter;
in
{
  options.hardware.gcadapter.enable = lib.mkEnableOption "GameCube Adapter support";

  config = lib.mkIf cfg.enable {
    services.udev.packages = [
      pkgs.dolphin-emu
    ];

    boot = {
      extraModulePackages = [
        config.boot.kernelPackages.gcadapter-oc-kmod
      ];

      kernelModules = [
        "gcadapter_oc"
      ];
    };
  };
}
