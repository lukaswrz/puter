{config, ...}: let
  inherit (config.networking) domain;
  virtualHostName = "sync.${domain}";
in {
  services.syncthing = {
    enable = true;
    systemService = true;
    openDefaultPorts = true;
    guiAddress = "localhost:8040";
  };

  services.nginx.virtualHosts.${virtualHostName} = {
    enableACME = true;
    forceSSL = true;

    locations."/".proxyPass = "http://${config.services.syncthing.guiAddress}";
  };
}
