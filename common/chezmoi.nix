{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.chezmoi
  ];
}
