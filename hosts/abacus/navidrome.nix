{ config, ... }:
{
  services.navidrome = {
    enable = true;
    settings = {
      Address = "127.0.0.1";
      Port = 8040;
      MusicFolder = "/srv/music";
      EnableSharing = true;
      Backup = {
        Path = "/srv/backup/navidrome";
        Count = 1;
        Schedule = "0 2 * * *";
      };
    };
  };

  services.nginx.virtualHosts."jam.moontide.ink" = {
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
