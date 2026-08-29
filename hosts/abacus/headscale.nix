{ config, ... }:
let
  proxyHost = config.proxyHosts.headscale;
in
{
  services.headscale = {
    enable = true;
    address = proxyHost.host;
    inherit (proxyHost) port;
    settings = {
      server_url = "https://${proxyHost.virtualHostName}";
      dns = {
        base_domain = "tailnet.moontide.ink";
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

  services.nginx.virtualHosts.${proxyHost.virtualHostName} = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://${proxyHost.address}";
      proxyWebsockets = true;
    };
  };
}
