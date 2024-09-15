{config, ...}: {
  fileSystems.${config.services.navidrome.settings.MusicFolder} = {
    label = "music";
    fsType = "ext4";
    options = ["noatime"];
  };
}
