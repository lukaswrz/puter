{config, ...}: let
  inherit (config.networking) domain;
  virtualHostName = "sync.${domain}";
in {
  services.syncthing = {
    enable = true;
    systemService = true;
    openDefaultPorts = true;
  };

  services.nginx.virtualHosts.${virtualHostName} = {
    enableACME = true;
    forceSSL = true;
    quic = true;

    locations."/".proxyPass = "http://${config.services.syncthing.guiAddress}";
  };
}
