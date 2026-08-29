{ config, lib, ... }:
let
  cfg = config.profiles.steam;
in
{
  options.profiles.steam = {
    enable = lib.mkEnableOption "steam";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      protontricks.enable = true;
      localNetworkGameTransfers.openFirewall = true;
      extest.enable = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
