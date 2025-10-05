{ config, ... }:
let
  virtualHostName = "bits.helveticanonstandard.net";
  cfg = config.services.filebrowser;
in
{
  services.filebrowser = {
    enable = true;
    settings = {
      address = "localhost";
      port = 8050;
    };
  };

  services.nginx.virtualHosts.${virtualHostName} = {
    enableACME = true;
    forceSSL = true;

    locations."/".proxyPass =
      let
        host = cfg.settings.address;
        port = builtins.toString cfg.settings.port;
      in
      "http://${host}:${port}";
  };
}
