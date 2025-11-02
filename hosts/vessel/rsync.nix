{
  services.rsync = {
    enable = true;
    jobs = {
      vault-sync = {
        sources = [ "/srv/vault/" ];
        destination = "/srv/sync";
        inhibit = [ "sleep" ];
        settings = {
          archive = true;
          delete = true;
          mkpath = true;
          checksum = true;
          verbose = [
            true
            true
          ];
          exclude = "lost+found/";
        };
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
      };
    };
  };
}
