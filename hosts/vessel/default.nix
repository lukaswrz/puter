{
  inputs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    # ./backup.nix
    # ./blocky.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
    kernelModules = ["kvm-intel"];
  };

  system.stateVersion = "24.05";

  powerManagement.cpuFreqGovernor = "powersave";

  environment.persistence."/persist".directories = ["/srv/storage"];
}
