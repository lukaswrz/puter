{
  programs.steam = {
    enable = true;
    extest.enable = true;
    protontricks.enable = true;
    dedicatedServer.openFirewall = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true; # TODO
  };
}
