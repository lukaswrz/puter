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
    quic = true;

    locations."/" = {
      proxyPass = "http://${config.services.syncthing.guiAddress}";

      extraConfig = ''
        proxy_set_header Host ${config.services.syncthing.guiAddress};
      '';
    };
  };
}
