self: {
  lib,
  config,
  pkgs,
  ...
}: let
  phps = let
    packages = self.packages.${pkgs.system};
    filter = name: _: (builtins.match "^php[[:digit:]]*$" name) != null;
  in
    lib.filterAttrs filter packages;
  cfg = config.services.myphps;
  inherit (lib) types;
in {
  options.services.myphps = {
    enable = lib.mkEnableOption "myphps";
    phps = lib.mkOption {
      description = ''
        PHPs to use.
      '';
      default = phps;
      type = types.attrsOf types.package;
    };
    prefix = lib.mkOption {
      description = ''
        The prefix for every PHP installation.
      '';
      default = "/run/phps";
      type = types.str;
    };
  };

  config = {
    systemd.tmpfiles.settings = lib.listToAttrs (lib.mapAttrsToList (name: drv: {
        name = "myphps-${name}";
        value = {
          "${cfg.prefix}/${name}"."L+".argument = drv.outPath;
        };
      })
      phps);
  };
}
