{config, ...}: {
  services.navidrome = {
    enable = true;
    settings = {
      Address = "127.0.0.1";
      Port = 8030;
      MusicFolder = "/srv/music";
    };
  };

  services.nginx.virtualHosts."navi.${config.networking.domain}" = {
    enableACME = true;
    forceSSL = true;
    quic = true;

    locations."/".proxyPass = "http://${config.services.navidrome.settings.Address}:${builtins.toString config.services.navidrome.settings.Port}";
  };

  fileSystems.${config.services.navidrome.settings.MusicFolder} = {
    device = "/dev/disk/by-label/music";
    fsType = "btrfs";
    options = ["compress=zstd" "noatime"];
  };
}
