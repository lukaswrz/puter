{ config, ... }:
let
  tailnet = config.services.headscale.settings.dns.base_domain;
in
{
  services.navidrome = {
    enable = true;
    settings = {
      Address = "127.0.0.1";
      Port = 8050;
      MusicFolder = "/srv/music";
      EnableSharing = true;
      Backup = {
        Path = "/srv/backup/navidrome";
        Count = 1;
        Schedule = "0 2 * * *";
      };
    };
  };

  services.nginx.virtualHosts."jam.helveticanonstandard.net" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass =
        let
          inherit (config.services.navidrome.settings) Address Port;
        in
        "http://${Address}:${toString Port}";
      proxyWebsockets = true;
    };
  };
}
