{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.setups.secureBoot;
in {
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  options.setups.secureBoot.enable = lib.mkEnableOption "Secure Boot";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.sbctl
    ];

    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = lib.mkForce true;
      pkiBundle = lib.mkDefault "/var/lib/sbctl";
    };
  };
}
