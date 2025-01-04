{
  pkgs,
  self,
  ...
}: {
  environment.systemPackages = [
    self.packages.${pkgs.system}.puter
  ];
}
