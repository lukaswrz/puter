{config, ...}: let
  inherit (config.networking) domain;
  virtualHostName = "flux.${domain}";
in {
  age.secrets.miniflux.file = ../../secrets/miniflux.age;

  services.miniflux = {
    enable = true;
    createDatabaseLocally = true;
    adminCredentialsFile = config.age.secrets.miniflux.path;
    config = {
      LISTEN_ADDR = "localhost:8030";
      BASE_URL = "https://${virtualHostName}";
      CREATE_ADMIN = 1;
      WEBAUTHN = 1;
    };
  };

  services.nginx.virtualHosts.${virtualHostName} = {
    enableACME = true;
    forceSSL = true;
    quic = true;

    locations."/".proxyPass = "http://${config.services.miniflux.config.LISTEN_ADDR}";
  };
}
