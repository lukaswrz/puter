{
  inputs,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"

    inputs.hardware.nixosModules.lenovo-thinkpad-t480
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod"];
    kernelModules = ["kvm-intel"];
  };

  powerManagement.cpuFreqGovernor = "powersave";

  console.keyMap = "de";
  services.xserver.xkb.layout = "de";
}
