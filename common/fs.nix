{
  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = ["size=4G" "mode=755"];
    };
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
    "/home".neededForBoot = true;
    "/nix" = {
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
    };
    "/persist" = {
      fsType = "btrfs";
      options = ["subvol=persist" "compress=zstd" "noatime"];
      neededForBoot = true;
    };
    "/tmp" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = ["size=8G" "mode=777"];
    };
    "/var/log" = {
      fsType = "btrfs";
      options = ["subvol=log" "compress=zstd" "noatime"];
      neededForBoot = true;
    };
  };

  environment.persistence."/persist" = {
    directories = ["/var/lib" "/var/cache"];
    files = ["/etc/machine-id"];
  };
}
