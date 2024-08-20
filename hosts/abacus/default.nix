{modulesPath, ...}: {
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"

    ./microbin.nix
    ./miniflux.nix
    ./nginx.nix
    ./syncthing.nix
    ./vaultwarden.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  boot.initrd.availableKernelModules = ["xhci_pci" "virtio_pci" "virtio_scsi" "usbhid" "sr_mod"];

  system.stateVersion = "24.11";

  powerManagement.cpuFreqGovernor = "performance";

  networking = let
    interface = "enp1s0";
  in {
    domain = "wrz.one";
    interfaces.${interface}.ipv6.addresses = [
      {
        address = "2a01:4f9:c012:92b5::2";
        prefixLength = 64;
      }
    ];
    defaultGateway6 = {
      address = "fe80::1";
      inherit interface;
    };
    firewall.allowedTCPPorts = [80 443];
  };

  security.acme = {
    defaults.email = "lukas@wrz.one";
    acceptTerms = true;
  };
}
