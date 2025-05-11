{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.myphps.nixosModules.default
  ];

  services.myphps = {
    enable = true;
    prefix = "/var/lib/phps";
  };

  environment.systemPackages = [
    pkgs.jetbrains.phpstorm
    config.services.myphps.phps.php
    inputs.myphps.packages.${pkgs.system}.symfony-cli
  ];
}
