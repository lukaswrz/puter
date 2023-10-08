{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  imports = [
    ./features/avahi.nix
    ./features/bluetooth.nix
    ./features/command-not-found.nix
    ./features/flatpak.nix
    ./features/fonts.nix
    ./features/fwupd.nix
    ./features/location.nix
    ./features/mullvad.nix
    ./features/opengl.nix
    ./features/openssh.nix
    ./features/opentabletdriver.nix
    ./features/pipewire.nix
    ./features/plasma.nix
    ./features/printing.nix
    ./features/sops.nix
    ./features/steam.nix
    ./features/sudo.nix
    ./features/users.nix
  ];

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = ["size=8G" "mode=755"];
    };

    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

    "/nix" = {
      device = "/dev/mapper/main";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
    };

    "/persist" = {
      device = "/dev/mapper/main";
      fsType = "btrfs";
      options = ["subvol=persist" "compress=zstd" "noatime"];
      neededForBoot = true;
    };

    "/home" = {
      device = "/dev/mapper/main";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd" "noatime"];
    };

    "/tmp" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = ["size=16G" "mode=777"];
    };

    "/var/log" = {
      device = "/dev/mapper/main";
      fsType = "btrfs";
      options = ["subvol=log" "compress=zstd" "noatime"];
      neededForBoot = true;
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
      "/var/cache"
      "/etc/NetworkManager"
      "/etc/mullvad-vpn"
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

    initrd.luks.devices.main.device = "/dev/disk/by-label/cryptmain";

    kernelParams = ["quiet" "splash" "vm.max_map_count=2147483642"];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;
  };

  zramSwap.enable = true;

  networking.networkmanager.enable = true;
  users.users.lukas.extraGroups = ["networkmanager"];

  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  console.keyMap = lib.mkDefault "us";
  services.xserver.layout = lib.mkDefault "us";

  programs.dconf.enable = true;

  xdg.portal.xdgOpenUsePortal = true;

  programs.kdeconnect.enable = true;
}
