{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.trusted;
in
{
  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "both";
    };

    networking.firewall.trustedInterfaces = [
      config.services.tailscale.interfaceName
    ];
  };
}
