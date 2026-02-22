{ lib, ... }:
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
    dump."/srv/dump".d = {
      user = "root";
      group = "users";
      mode = "0755";
    };
    syncthing =
      lib.genAttrs
        [
          "/srv/vault"
          "/srv/void"
        ]
        (_: {
          A.argument = "d:u:syncthing:rwx";
        });
    m64 =
      lib.genAttrs
        [
          "/srv/vault"
          "/srv/void"
          "/srv/dump"
          "/srv/media"
        ]
        (_: {
          A.argument = "d:u:m64:rwx";
        });
    jellyfin."/srv/media".A.argument = "d:u:jellyfin:rwx";
  };
}
