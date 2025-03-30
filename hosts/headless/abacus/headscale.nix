{config, ...}: let
  virtualHostName = "headscale.helveticanonstandard.net";
in {
  services.headscale = {
    enable = true;
    address = "127.0.0.1";
    port = 8010;
    server_url = "https://${virtualHostName}";
    settings = {
      logtail.enabled = false;
    };
  };

  services.nginx.virtualHosts.${virtualHostName} = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://localhost:${builtins.toString config.services.headscale.port}";
      proxyWebsockets = true;
    };
  };
}
