let
  guiPort = 8384;
in {
  services.syncthing = {
    enable = true;
    systemService = true;
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:${guiPort}";
  };

  networking.firewall.allowedTCPPorts = [guiPort];
}
