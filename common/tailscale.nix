{ config, ... }:
{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "both"; # TODO
  };

  networking.firewall.trustedInterfaces = [
    config.services.tailscale.interfaceName
  ];
}
