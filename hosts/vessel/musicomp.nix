{
  services.musicomp.jobs.main = {
    music = "/srv/vault/music";
    comp = "/srv/compressed-music";
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
    inhibit = [ "sleep" ];
  };
}
