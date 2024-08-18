{
  systemd.tmpfiles.settings = {
    "10-safe"."/srv/safe".d = {
      user = "root";
      group = "root";
      mode = "0755";
    };

    "10-storage"."/srv/storage".d = {
      user = "root";
      group = "root";
      mode = "0755";
    };
  };
}
