{ config, ... }:
{
  services.navidrome = {
    enable = true;
    settings = {
      Address = "abacus.tailnet.helveticanonstandard.net";
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
