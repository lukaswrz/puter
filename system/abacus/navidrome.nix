{config, ...}: let
  musicDir = "/srv/music";
in {
  services.navidrome = {
    enable = true;

    settings = {
      Address = "127.0.0.1";
      Port = 8040;
      MusicFolder = musicDir;
    };
  };

  services.nginx.virtualHosts."music.defenestrated.systems" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      recommendedProxySettings = true;
      proxyPass = "http://127.0.0.1:${builtins.toString config.services.navidrome.settings.Port}";
    };
  };

  fileSystems.${musicDir} = {
    device = "/dev/disk/by-label/storage";
    fsType = "btrfs";
    options = ["subvol=music" "compress=zstd" "noatime"];
  };
}
