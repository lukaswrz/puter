{
  boot.initrd.luks.devices = {
    main.device = "/dev/disk/by-label/cryptmain";
    vault.device = "/dev/disk/by-label/cryptvault";
    void.device = "/dev/disk/by-label/cryptvoid";
    sync.device = "/dev/disk/by-label/cryptsync";
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/main";
      fsType = "ext4";
      options = [
        "noatime"
      ];
    };
    "/srv/vault" = {
      device = "/dev/mapper/vault";
      fsType = "ext4";
      options = [
        "noatime"
      ];
    };
    "/srv/void" = {
      device = "/dev/mapper/void";
      fsType = "ext4";
      options = [
        "noatime"
      ];
    };
    "/srv/sync" = {
      device = "/dev/mapper/sync";
      fsType = "ext4";
      options = [
        "noatime"
      ];
    };
  };
}
