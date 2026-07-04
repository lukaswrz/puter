{ lib, ... }:
{
  systemd.tmpfiles.settings = {
    music = {
      "/srv/vault/music".d = {
        user = "root";
        group = "root";
        mode = "0755";
      };
      "/srv/compressed-music".d = {
        user = "root";
        group = "root";
        mode = "0755";
      };
    };

    navidrome."/srv/compressed-music".A.argument = "d:u:navidrome:rx";

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
          "/srv/media"
          "/srv/old-media"
        ]
        (_: {
          A.argument = "d:u:helvetica:rwx";
        });

    jellyfin =
      lib.genAttrs
        [
          "/srv/media"
          "/srv/old-media"
          "/srv/compressed-music"
        ]
        (_: {
          A.argument = "d:u:jellyfin:rwx";
        });
  };
}
