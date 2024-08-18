let
  guiPort = 8384;
in {
  services.syncthing = {
    enable = true;
    systemService = true;
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:${builtins.toString guiPort}";
  };

  networking.firewall.allowedTCPPorts = [guiPort];
}
