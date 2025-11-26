{
  config,
  inputs,
  ...
}:
{
  age.secrets.miniflux.file = inputs.self + /secrets/miniflux.age;

  services.miniflux = {
    enable = true;
    createDatabaseLocally = true;
    adminCredentialsFile = config.age.secrets.miniflux.path;
    config = {
      LISTEN_ADDR = "${config.networking.hostName}.tailent.helveticanonstandard.net:6010";
      BASE_URL = "http://${config.networking.hostName}.tailent.helveticanonstandard.net";
      CREATE_ADMIN = 1;
      WEBAUTHN = 1;
    };
  };

  services.nginx.virtualHosts."miniflux.helveticanonstandard.net" = {
    listen = [
      {
        addr = "localhost";
        port = 80;
      }
    ];

    #extraConfig = ''
    #  allow 100.64.0.0/10;
    #  allow fd7a:115c:a1e0::/48;
    #  deny all;
    #'';

    locations."/" = {
      proxyPass = "http://${config.services.miniflux.config.LISTEN_ADDR}";
      proxyWebsockets = true;
    };
  };
}
