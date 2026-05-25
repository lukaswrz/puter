{
  networking =
    let
      interface = "enp7s0";
    in
    {
      domain = "moontide.ink";
      interfaces.${interface}.ipv6.addresses = [
        {
          address = "2a03:4000:60:eeb:cfc8:7f6b:3936:49e4";
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
