{pkgs, ...}: {
  networking.nftables.enable = true;

  environment.systemPackages = [
    pkgs.nixos-firewall-tool
  ];
}
