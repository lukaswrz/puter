{
  pkgs,
  inputs,
  config,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    inputs.hardware.nixosModules.lenovo-thinkpad-x260
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod"];
    kernelModules = ["kvm-intel"];
  };

  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

  system.stateVersion = "23.11";

  powerManagement.cpuFreqGovernor = "powersave";

  console.keyMap = "de";
  services.xserver.layout = "de";
}
