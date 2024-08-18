{
  inputs,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"

    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    ./backup.nix
    ./blocky.nix
    ./storage.nix
    ./syncthing.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
    kernelModules = ["kvm-intel"];
  };

  system.stateVersion = "24.11";

  powerManagement.cpuFreqGovernor = "powersave";
}
