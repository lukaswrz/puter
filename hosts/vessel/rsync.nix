{ pkgs, ... }:
{
  services.rsync = {
    enable = true;
    jobs = {
      vault = {
        sources = [ "/srv/vault/" ];
        destination = "/srv/sync";
        inhibit = [ "sleep" ];
        settings = {
          archive = true;
          delete = true;
          mkpath = true;
          exclude = "lost+found/";
        };
      };

      roms = {
        sources = [ "/srv/vault/roms/" ];
        destination = "insomniac@kaleidoscope:~/Roms";
        inhibit = [ "sleep" ];
        settings = {
          archive = true;
          delete = true;
          mkpath = true;
        };
      };

      movies = {
        sources = [ "/srv/vault/movies/" ];
        destination = "insomniac@kaleidoscope:~/Videos/Movies";
        inhibit = [ "sleep" ];
        settings = {
          archive = true;
          delete = true;
          mkpath = true;
        };
      };
    };
  };
}
