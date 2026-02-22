{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.jujutsu
  ];
}
