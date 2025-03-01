{
  pkgs,
  self,
  ...
}: {
  environment = {
    systemPackages = [
      self.packages.${pkgs.system}.puter
    ];
    sessionVariables.PUTER_FLAKEREF = "git+https://forgejo@tea.wrz.one/lukas/puter.git";
  };
}
