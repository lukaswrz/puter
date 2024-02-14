{
  environment.persistence."/persist".directories = ["/etc/NetworkManager"];

  services.resolved.enable = true;

  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    firewall = {
      allowedTCPPorts = [
        # Spotify track sync
        57621
        # Steam Remote Play
        27036
        # Source Dedicated Server SRCDS Rcon port
        27015
        # Syncthing TCP based sync protocol traffic
        22000
      ];
      allowedUDPPorts = [
        # Source Dedicated Server gameplay traffic
        27015
        # Syncthing QUIC based sync protocol traffic
        22000
        # Syncthing port for discovery broadcasts on IPv4 and multicasts on IPv6
        21027
      ];
      allowedUDPPortRanges = [
        # Steam Remote Play
        {
          from = 27031;
          to = 27036;
        }
      ];
    };
  };
}
