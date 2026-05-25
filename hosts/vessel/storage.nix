{ lib, ... }:
{
  systemd.tmpfiles.settings = {
    music = {
      "/srv/vault/music".d = {
        user = "root";
        group = "root";
        mode = "0755";
      };
      "/srv/shrink".d = {
        user = "root";
        group = "root";
        mode = "0755";
      };
    };
    dump."/srv/dump".d = {
      user = "root";
      group = "root";
      mode = "0755";
    };
    navidrome."/srv/shrink".A.argument = "d:u:navidrome:rx";
    syncthing =
      lib.genAttrs
        [
          "/srv/vault"
          "/srv/void"
        ]
        (_: {
          A.argument = "d:u:syncthing:rwx";
        });
    helvetica =
      lib.genAttrs
        [
          "/srv/vault"
          "/srv/void"
          "/srv/dump"
          "/srv/media"
        ]
        (_: {
          A.argument = "d:u:helvetica:rwx";
        });
    jellyfin."/srv/media".A.argument = "d:u:jellyfin:rwx";
  };
}
