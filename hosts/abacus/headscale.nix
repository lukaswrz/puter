{ config, ... }:
let
  virtualHostName = "headscale.helveticanonstandard.net";
in
{
  services.headscale = {
    enable = true;
    address = "127.0.0.1";
    port = 8000;
    settings = {
      server_url = "https://${virtualHostName}";
      dns = {
        base_domain = "tailnet.helveticanonstandard.net";
        nameservers.global = [
          "1.1.1.1"
          "1.0.0.1"
          "2606:4700:4700::1111"
          "2606:4700:4700::1001"
        ];
      };
      logtail.enabled = false;
    };
  };

  services.nginx.virtualHosts.${virtualHostName} = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass =
        let
          host = config.services.headscale.address;
          port = builtins.toString config.services.headscale.port;
        in
        "http://${host}:${port}";
      proxyWebsockets = true;
    };
  };
}
