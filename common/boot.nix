{ config, ... }:
{
  fileSystems.${config.boot.loader.efi.efiSysMountPoint} = {
    label = "BOOT";
    fsType = "vfat";
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    # TODO
    tmp = {
      useTmpfs = true;
      tmpfsSize = "50%";
      cleanOnBoot = true;
    };
  };
}
