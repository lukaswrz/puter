{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.jovian;
in
{
  imports = [
    inputs.jovian.nixosModules.default
  ];

  options.profiles.jovian = {
    enable = lib.mkEnableOption "jovian";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.profiles.steam.enable;
        message = "The jovian profile depends on the steam profile.";
      }
    ];

    jovian = {
      steam = {
        enable = true;
        desktopSession = "plasma";
        autoStart = true;
        user = "insomniac";
      };
      hardware.has.amd.gpu = true;
    };

    services.desktopManager.plasma6.enable = true;

    environment.systemPackages = [
      pkgs.librewolf
    ];
  };
}
