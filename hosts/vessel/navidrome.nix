{
  services.navidrome = {
    enable = true;
    settings = {
      Address = "vessel.tailnet.moontide.ink";
      Port = 4533;
      MusicFolder = "/srv/shrink";
      EnableSharing = true;
      Backup = {
        Path = "/srv/backup/navidrome";
        Count = 1;
        Schedule = "0 2 * * *";
      };
    };
  };
}
