{ config, ... }:
{
  fileSystems.${config.boot.loader.efi.efiSysMountPoint} = {
    label = "BOOT";
    fsType = "vfat";
  };

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    initrd.systemd.enable = true;

    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };
}
