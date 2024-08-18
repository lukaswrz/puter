{
  boot.tmp.cleanOnBoot = true;

  fileSystems = {
    "/" = {
      fsType = "ext4";
      label = "main";
      options = ["noatime"];
    };
    "/boot" = {
      label = "BOOT";
      fsType = "vfat";
    };
  };
}
