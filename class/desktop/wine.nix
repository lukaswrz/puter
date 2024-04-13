{pkgs, ...}: {
  environment.systemPackages = [pkgs.wineWowPackages.stableFull];
}
