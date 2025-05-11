{ config, ... }:
{
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall = {
    trustedInterfaces = [
      config.services.tailscale.interfaceName
    ];
    # Required to connect to Tailscale exit nodes
    checkReversePath = "loose";
  };
}
