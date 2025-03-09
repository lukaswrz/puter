{
  services.tailscale = {
    enable = true;
    openFirewall = true; #TODO
  };

  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
  };
}
