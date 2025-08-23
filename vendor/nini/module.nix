self:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.nini;
  inherit (lib) types;
in
{
  options.programs.nini = {
    enable = lib.mkEnableOption "nini";
    package = lib.mkPackageOption self.packages.${pkgs.system} "default" { };
    flake = lib.mkOption {
      type = types.str;
      description = ''
        The flake for nini.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [
        cfg.package
      ];
      sessionVariables.NINI_FLAKE = cfg.flake;
    };
  };
}
