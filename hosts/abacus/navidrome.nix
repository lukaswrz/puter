{ config, ... }:
let
  tailnet = config.services.headscale.settings.dns.base_domain;
in
{
  services.navidrome = {
    enable = true;
    settings = {
      Address = "${config.networking.hostName}.${tailnet}";
      Port = 6000;
      MusicFolder = "/srv/music";
      EnableSharing = true;
      # TODO
      # Backup = {
      #   Path = "/srv/backup/navidrome";
      #   Count = 1;
      #   Schedule = "0 2 * * *";
      # };
    };
  };
}
