{
  config,
  lib,
  ...
}:
let
  cfg = config.hardware.gcadapter;
in
{
  options.hardware.gcadapter.enable = lib.mkEnableOption "GameCube Adapter support";

  config = lib.mkIf cfg.enable {
    services.udev.extraRules = ''
      ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="666", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device" TAG+="uaccess"
    '';

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
