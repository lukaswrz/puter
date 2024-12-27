{pkgs, ...}: {
  networking = {
    nftables.enable = true;
    useNetworkd = true;
  };

  environment.systemPackages = [
    pkgs.nixos-firewall-tool
  ];
}
