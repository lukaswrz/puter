{config, ...}: let
  virtualHostName = "mealie.helveticanonstandard.net";
in {
  services.mealie = {
    enable = true;
    settings = {
      BASE_URL = "https://${virtualHostName}";
      ALLOW_SIGNUP = false;
    };
    listenAddress = "127.0.0.1";
    port = 8040;
  };

  services.nginx.virtualHosts.${virtualHostName} = {
    enableACME = true;
    forceSSL = true;

    locations."/".proxyPass = let
      host = config.services.mealie.listenAddress;
      port = builtins.toString config.services.mealie.port;
    in "http://${host}:${port}";
  };
}
