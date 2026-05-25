{
  services.musicomp.jobs.main = {
    music = "/srv/vault/music";
    comp = "/srv/shrink";
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
    inhibit = [ "sleep" ];
  };
}
