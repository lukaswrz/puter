{ lib, ... }:
{
  systemd.tmpfiles.settings = {
    music =
      lib.genAttrs
        [
          "/srv/vault/music"
          "/srv/maw/compressed-music"
        ]
        (_: {
          d = {
            user = "root";
            group = "root";
            mode = "0755";
          };
        });

    navidrome = {
      "/srv/maw/compressed-music".A.argument = "d:u:navidrome:rx";
      "/srv/backup/navidrome".d = {
        user = "navidrome";
        group = "navidrome";
        mode = "0755";
      };
    };

    syncthing =
      lib.genAttrs
        [
          "/srv/vault"
          "/srv/void"
          "/srv/maw"
        ]
        (_: {
          A.argument = "d:u:syncthing:rwx";
        });

    lukas =
      lib.genAttrs
        [
          "/srv/vault"
          "/srv/void"
          "/srv/media"
          "/srv/maw"
          "/srv/old-media"
        ]
        (_: {
          A.argument = "d:u:lukas:rwx";
        });

    jellyfin =
      lib.genAttrs
        [
          "/srv/media"
          "/srv/old-media"
        ]
        (_: {
          A.argument = "d:u:jellyfin:rwx";
        });
  };
}
