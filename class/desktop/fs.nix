{
  boot.initrd.luks.devices.main.device = "/dev/disk/by-label/cryptmain";

  fileSystems = {
    "/home" = {
      device = "/dev/mapper/main";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd" "noatime"];
    };
    "/nix".device = "/dev/mapper/main";
    "/persist".device = "/dev/mapper/main";
    "/var/log".device = "/dev/mapper/main";
  };
}
