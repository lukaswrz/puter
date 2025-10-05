{ config, ... }:
let
  virtualHostName = "jam.helveticanonstandard.net";
in
{
  services.navidrome = {
    enable = true;
    settings = {
      Address = "localhost";
      Port = 8030;
      MusicFolder = "/srv/music";
      EnableSharing = true;
      Backup = {
        Path = "/srv/backup/navidrome";
        Count = 1;
        Schedule = "0 2 * * *";
      };
    };
  };

  services.nginx.virtualHosts.${virtualHostName} = {
    enableACME = true;
    forceSSL = true;

    locations."/".proxyPass =
      let
        host = config.services.navidrome.settings.Address;
        port = builtins.toString config.services.navidrome.settings.Port;
      in
      "http://${host}:${port}";
  };
}
