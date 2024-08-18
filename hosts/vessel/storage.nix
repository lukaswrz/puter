{
  systemd.tmpfiles.settings = {
    "10-safe"."/srv/safe".d = {
      user = "lukas";
      group = "users";
      mode = "0755";
    };

    "10-storage"."/srv/storage".d = {
      user = "lukas";
      group = "users";
      mode = "0755";
    };
  };
}
