{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.gaming;
in
{
  config = lib.mkIf cfg.enable {
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };
  };
}
