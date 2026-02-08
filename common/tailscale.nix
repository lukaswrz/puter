{
  config,
  ...
}:
{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "both";
  };

  networking.firewall.trustedInterfaces = [
    config.services.tailscale.interfaceName
  ];
}
