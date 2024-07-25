{
  boot.initrd.luks.devices.main.device = "/dev/disk/by-label/cryptmain";

  fileSystems."/".device = "/dev/mapper/main";

  boot.supportedFilesystems = ["ntfs"];
}
