{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.mullvad;
in
{
  options.profiles.mullvad = {
    enable = lib.mkEnableOption "mullvad";
  };

  config = lib.mkIf cfg.enable {
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };
}
