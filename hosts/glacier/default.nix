{
  inputs,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"

    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ./printing.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    initrd = {
      availableKernelModules = ["nvme" "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = ["amdgpu"];
    };
    kernelModules = ["kvm-amd"];
    binfmt.emulatedSystems = ["aarch64-linux"];
  };

  system.stateVersion = "24.11";

  powerManagement.cpuFreqGovernor = "performance";
}
