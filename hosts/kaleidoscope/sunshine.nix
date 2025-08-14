{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
  };

  networking.firewall =
    let
      basePort = 47989;
      generatePorts = port: offsets: builtins.map (offset: port + offset) offsets;
    in
    {
      allowedTCPPorts = generatePorts basePort [
        (-5)
        0
        1
        21
      ];
      allowedUDPPorts = generatePorts basePort [
        9
        10
        11
        13
        21
      ];
    };
}
