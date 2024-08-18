let
  guiPort = 8384;
in {
  services.syncthing = {
    enable = true;
    systemService = true;
    openDefaultPorts = true;
    guiAddress = "127.0.0.1:${builtins.toString guiPort}";
  };

  networking.firewall.allowedTCPPorts = [guiPort];
}
