{config, ...}: let
  inherit (config.networking) domain;
  virtualHostName = "bin.${domain}";
in {
  services.miniflux = {
    enable = true;
    createDatabaseLocally = true;
    adminCredentialsFile = "";
    config = {
      LISTEN_ADDR = "localhost:8040";
      BASE_URL = "https://${virtualHostName}";
      WEBAUTHN = true;
    };
  };

  services.nginx.virtualHosts.${virtualHostName} = {
    enableACME = true;
    forceSSL = true;
    quic = true;

    locations."/".proxyPass = "http://${config.services.miniflux.config.LISTEN_ADDR}";
  };
}
