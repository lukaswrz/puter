{
  boot.tmp.cleanOnBoot = true;

  fileSystems = {
    "/" = {
      fsType = "ext4";
      options = ["noatime"];
    };
    "/boot" = {
      label = "BOOT";
      fsType = "vfat";
    };
  };
}
