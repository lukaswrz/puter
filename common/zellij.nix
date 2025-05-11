{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.zellij
  ];
}
