{ configName, pkgs, ... }:
{
  networking = {
    hostName = configName;
    nftables.enable = true;
  };

  environment.systemPackages = [
    pkgs.nixos-firewall-tool
  ];
}
