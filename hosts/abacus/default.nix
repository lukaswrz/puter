{modulesPath, ...}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")

    ./mailserver.nix
    ./nextcloud.nix
    ./nginx.nix
    ./static.nix
    ./vaultwarden.nix
    # TODO: dendrite/conduit, gitea/forgejo
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  boot.initrd.availableKernelModules = ["xhci_pci" "virtio_pci" "virtio_scsi" "usbhid" "sr_mod"];

  system.stateVersion = "24.05";

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
    defaults.email = "lukasatwrzdotone@gmail.com";
    acceptTerms = true;
  };
}
