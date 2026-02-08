{ attrName, pkgs, ... }:
{
  networking = {
    hostName = attrName;
    nftables.enable = true;
  };

  environment.systemPackages = [
    pkgs.nixos-firewall-tool
  ];
}
