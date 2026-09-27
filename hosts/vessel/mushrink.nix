{
  services.mushrink.jobs.main = {
    input = "/srv/vault/music";
    output = "/srv/compressed-music";
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
    inhibit = [ "sleep" ];
  };
}
