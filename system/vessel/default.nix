{
  lib,
  pkgs,
  inputs,
  config,
  self,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    ./backup.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    initrd.availableKernelModules = ["ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod"];
    kernelModules = ["kvm-intel"];
  };

  system.stateVersion = "23.11";

  powerManagement.cpuFreqGovernor = "performance";

  fileSystems."/srv/storage" = {
    device = "/dev/disk/by-label/storage";
    fsType = "btrfs";
    options = ["subvol=main" "compress=zstd" "noatime"];
  };
}
