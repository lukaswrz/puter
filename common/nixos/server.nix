{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  imports = [
    (inputs.impermanence + "/nixos.nix")

    ./features/avahi.nix
    ./features/command-not-found.nix
    ./features/openssh.nix
    ./features/sops.nix
    ./features/sudo.nix
    ./features/users.nix
  ];

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

    "/nix" = {
      device = "/dev/disk/by-label/main";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
    };

    "/persist" = {
      device = "/dev/disk/by-label/main";
      fsType = "btrfs";
      options = ["subvol=persist" "compress=zstd" "noatime"];
      neededForBoot = true;
    };

    "/home" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = ["size=4G" "mode=751"];
      neededForBoot = true;
    };

    "/tmp" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = ["size=16G" "mode=777"];
    };

    "/var/log" = {
      device = "/dev/disk/by-label/main";
      fsType = "btrfs";
      options = ["subvol=log" "compress=zstd" "noatime"];
      neededForBoot = true;
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
      "/srv"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

  programs.fuse.userAllowOther = true;

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
  };

  zramSwap.enable = true;

  time.timeZone = lib.mkDefault "UTC";
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  console.keyMap = lib.mkDefault "us";
  services.xserver.layout = lib.mkDefault "us";
}
