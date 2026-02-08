{ config, ... }:
{
  programs.starship.enable = true;

  environment.systemPackages = [
    config.programs.starship.package
  ];
}
