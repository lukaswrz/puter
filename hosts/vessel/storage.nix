{
  systemd.tmpfiles.settings = {
    music = {
      "/srv/vault/music".d = {
        user = "root";
        group = "users";
        mode = "0755";
      };
      "/srv/void/compmusic".d = {
        user = "root";
        group = "users";
        mode = "0755";
      };
    };
  };
}
