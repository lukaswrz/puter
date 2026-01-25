{ lib, config, ... }:
{
  systemd.tmpfiles.settings = {
    music = {
      "/srv/vault/music".d = {
        user = "root";
        group = "users";
        mode = "0755";
      };
      "/srv/shrink".d = {
        user = "root";
        group = "users";
        mode = "0755";
      };
    };
    syncthing =
      lib.genAttrs
        [
          "/srv/vault"
          "/srv/void"
          "/srv/shrink"
          "/srv/vault"
        ]
        (_: {
          A.argument = "d:u:syncthing:rwx";
        });
  };
}
