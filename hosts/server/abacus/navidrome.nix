{
  config,
  lib,
  ...
}: let
  inherit (config.networking) domain;
  virtualHostName = "navi.${domain}";
in {
  services.navidrome = {
    enable = true;
    settings = {
      Address = "localhost";
      Port = 8050;
      MusicFolder = "/srv/music";
    };
  };

  services.nginx.virtualHosts.${virtualHostName} = {
    enableACME = true;
    forceSSL = true;

    locations."/".proxyPass = "http://${lib.formatHostPort {
      host = config.services.navidrome.settings.Address;
      port = config.services.navidrome.settings.Port;
    }}";
  };
}
