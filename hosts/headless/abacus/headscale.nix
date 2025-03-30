{config, ...}: let
  virtualHostName = "headscale.helveticanonstandard.net";
in {
  services.headscale = {
    enable = true;
    address = "127.0.0.1";
    port = 8010;
    settings = {
      server_url = "https://${virtualHostName}";
      logtail.enabled = false;
    };
  };

  services.nginx.virtualHosts.${virtualHostName} = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = let
        host = config.services.headscale.address;
        port = builtins.toString config.services.headscale.port;
      in "http://${host}:${port}";
      proxyWebsockets = true;
    };
  };
}
