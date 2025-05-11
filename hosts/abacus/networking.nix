{
  networking =
    let
      interface = "enp1s0";
    in
    {
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
      firewall.allowedTCPPorts = [
        80
        443
      ];
    };
}
