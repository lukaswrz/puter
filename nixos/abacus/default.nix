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
    (modulesPath + "/profiles/qemu-guest.nix")

    ./gitea.nix
    ./hiraeth.nix
    ./navidrome.nix
    ./vaultwarden.nix
    ./woodpecker.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  boot.initrd.availableKernelModules = ["xhci_pci" "virtio_pci" "virtio_scsi" "usbhid" "sr_mod"];

  system.stateVersion = "23.11";

  powerManagement.cpuFreqGovernor = "performance";

  networking = {
    interfaces.enp1s0.ipv6.addresses = [
      {
        address = "2a01:4f8:c012:24ed::2";
        prefixLength = 64;
      }
    ];
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp1s0";
    };
    firewall.allowedTCPPorts = [80 443];
  };

  security.acme = {
    defaults.email = "lukas@wrz.one";
    acceptTerms = true;
  };

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedBrotliSettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;

    virtualHosts = {
      "wrz.one" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          root = "/srv/http/wrz.one";
        };
      };

      "defenestrated.systems" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          root = "/srv/http/defenestrated.systems";
        };
      };

      "static.defenestrated.systems" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          root = "/srv/http/static.defenestrated.systems";
        };
      };
    };
  };
}
