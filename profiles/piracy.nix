{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.piracy;
in
{
  options.profiles.piracy = {
    enable = lib.mkEnableOption "piracy";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.profiles.desktop.enable;
        message = "The piracy profile depends on the desktop profile.";
      }
    ];

    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };

    environment.systemPackages = [
      pkgs.qbittorrent
    ];
  };
}
