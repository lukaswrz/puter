{config, ...}: let
  virtualHostName = "filebrowser.helveticanonstandard.net";
  cfg = config.services.filebrowser;
in{
  services.filebrowser = {
    enable = true;
    settings = {
      address = "localhost";
      port = 8090;
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
