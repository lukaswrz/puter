{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.gaming;
in
{
  config = lib.mkIf cfg.enable {
  programs.steam = {
    enable = true;
    extest.enable = true;
    protontricks.enable = true;
    dedicatedServer.openFirewall = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  };
}
