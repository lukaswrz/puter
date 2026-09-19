{
  services.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/srv/compressed-music";
      EnableSharing = true;
      Backup = {
        Path = "/srv/backup/navidrome";
        Count = 1;
        Schedule = "0 2 * * *";
      };
    };
  };
}
