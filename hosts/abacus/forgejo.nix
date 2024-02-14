{config, ...}: let
  virtualHostName = "tea.${config.networking.domain}";
in {
  services.forgejo = {
    enable = true;

    database.type = "postgres";

    lfs.enable = true;

    settings = {
      session = {
        COOKIE_SECURE = true;
        PROVIDER = "db";
      };

      service = {
        DISABLE_REGISTRATION = true;
      };

      server = {
        PROTOCOL = "http";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 8020;
        DOMAIN = virtualHostName;
        ROOT_URL = "https://${virtualHostName}/";
      };
    };
  };

  services.nginx.virtualHosts.${virtualHostName} = {
    enableACME = true;
    forceSSL = true;
    quic = true;

    locations."/".proxyPass = "http://${config.services.forgejo.settings.server.HTTP_ADDR}:${builtins.toString config.services.forgejo.settings.server.HTTP_PORT}";
  };
}
