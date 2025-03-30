{config, ...}: {
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
    interfaces.${config.services.tailscale.interfaceName} = {
      allowedTCPPorts = [4000];
    };
  };
}
