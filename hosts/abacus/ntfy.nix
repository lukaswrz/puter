{ config, ... }:
{
  services.ntfy-sh = {
    enable = true;
    settings = {
      listen-http = "localhost:8050";
      auth-default-access = "deny-all";
    };
  };

  services.nginx.virtualHosts."poke.helveticanonstandard.net" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://${config.services.ntfy-sh.settings.listen-http}";
      proxyWebsockets = true;
    };
  };
}
