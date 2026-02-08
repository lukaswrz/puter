{ config, ... }:
{
  networking =
    let
      interface = "enp1s0";
    in
    {
      domain = "helveticanonstandard.net";
      interfaces.${interface}.ipv6.addresses = [
        {
          address = "2a01:4f8:c013:e64a::2";
          prefixLength = 64;
        }
      ];
      defaultGateway6 = {
        address = "fe80::1";
        inherit interface;
      };
      firewall.allowedTCPPorts = [
        80
        443
      ];
    };
}
