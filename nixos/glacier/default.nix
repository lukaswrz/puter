{
  pkgs,
  inputs,
  config,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ../features/flatpak.nix
    ../features/opentabletdriver.nix
    ../features/printing.nix
    ../features/steam.nix
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

  hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

  system.stateVersion = "23.11";

  powerManagement.cpuFreqGovernor = "performance";

  services.printing.drivers = with pkgs; [
    epson-escpr
    epson-escpr2
  ];

  services.mullvad-vpn.enable = true;
}
