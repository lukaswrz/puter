{ config, ... }:
{
  fileSystems = {
    "/" = {
      fsType = "ext4";
      label = "main";
      options = [
        "noatime"
      ];
    };
    ${config.services.navidrome.settings.MusicFolder} = {
      label = "music";
      fsType = "ext4";
      options = [
        "noatime"
      ];
    };
  };
}
