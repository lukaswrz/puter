{lib, ...}: let
  guiPort = 8384;
in {
  services.syncthing = {
    enable = true;
    systemService = true;
    openDefaultPorts = true;
    guiAddress = lib.formatHostPort {
      host = "0.0.0.0";
      port = guiPort;
    };
  };

  networking.firewall.allowedTCPPorts = [guiPort];
}
