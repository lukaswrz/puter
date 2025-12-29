{
  boot.initrd.luks.devices.main.device = "/dev/disk/by-label/cryptmain";

  fileSystems."/" = {
    fsType = "ext4";
    device = "/dev/mapper/main";
    options = [
      "noatime"
    ];
  };
}
