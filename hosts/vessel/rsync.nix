{
  services.rsync.jobs = {
    vault = {
      sources = [ "/srv/vault/" ];
      destination = "/srv/sync";
      inhibitsSleep = true;
    };

    roms = {
      sources = [ "/srv/vault/roms/" ];
      destination = "insomniac@kaleidoscope:~/Roms";
      inhibitsSleep = true;
    };

    movies = {
      sources = [ "/srv/vault/movies/" ];
      destination = "insomniac@kaleidoscope:~/Videos/Movies";
      inhibitsSleep = true;
    };

    anime = {
      sources = [ "/srv/vault/anime/" ];
      destination = "insomniac@kaleidoscope:~/Videos/Anime";
      inhibitsSleep = true;
    };
  };
}
