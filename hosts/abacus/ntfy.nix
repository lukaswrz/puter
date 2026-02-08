{ config, inputs, ... }:
let
  virtualHostName = "poke.helveticanonstandard.net";
in
{
  age.secrets.ntfy = {
    file = inputs.self + /secrets/ntfy.age;
    mode = "400";
    owner = config.services.ntfy-sh.user;
  };

  services.ntfy-sh = {
    enable = true;
    settings = {
      listen-http = "localhost:8040";
      auth-default-access = "deny-all";
      base-url = "https://${virtualHostName}";
    };

    environmentFile = config.age.secrets.ntfy.path;
  };

  services.nginx.virtualHosts.${virtualHostName} = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://${config.services.ntfy-sh.settings.listen-http}";
      proxyWebsockets = true;
    };
  };
}
