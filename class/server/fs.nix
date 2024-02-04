{
  fileSystems = {
    "/home" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = ["size=4G" "mode=751"];
    };
    "/nix".device = "/dev/disk/by-label/main";
    "/persist".device = "/dev/disk/by-label/main";
    "/var/log".device = "/dev/disk/by-label/main";
  };
}
