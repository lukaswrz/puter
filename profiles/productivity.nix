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
  options.profiles.productivity = {
    enable = lib.mkEnableOption "productivity";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.profiles.desktop.enable;
        message = "The productivity profile depends on the desktop profile.";
      }
    ];

    environment.systemPackages = [
      pkgs.gimp
      pkgs.inkscape
      pkgs.libreoffice
      pkgs.libresprite
    ];
  };
}
