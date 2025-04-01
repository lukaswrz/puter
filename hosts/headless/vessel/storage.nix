{
  systemd.tmpfiles.settings = {
    "10-safe"."/srv/safe".d = {
      user = "helvetica";
      group = "users";
      mode = "0755";
    };

    "10-storage"."/srv/storage".d = {
      user = "helvetica";
      group = "users";
      mode = "0755";
    };

    "10-music"."/srv/music".d = {
      user = "helvetica";
      group = "users";
      mode = "0755";
    };

    "10-compmusic"."/srv/compmusic".d = {
      user = "helvetica";
      group = "users";
      mode = "0755";
    };
  };
}
