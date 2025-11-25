{ config, ... }:
let
  virtualHostName = "poke.helveticanonstandard.net";
in
{
  # services.ntfy-sh = {
  #   enable = true;
  #   settings = {
  #     listen-http = "localhost:8050";
  #     auth-default-access = "deny-all";
  #     base-url = "https://${virtualHostName}";
  #     require-login = true;
  #     web-root = "disable";
  #   };
  # };

  # services.nginx.virtualHosts.${virtualHostName} = {
  #   enableACME = true;
  #   forceSSL = true;

  #   locations."/" = {
  #     proxyPass = "http://${config.services.ntfy-sh.settings.listen-http}";
  #     proxyWebsockets = true;
  #   };
  # };
}
