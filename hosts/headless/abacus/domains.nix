{lib, ...}: let
  inherit (lib) types;
in {
  options.networking.domains = lib.mkOption {
    description = "Domains.";
    type = types.attrsOf types.str;
    default = {};
  };

  config.networking.domains = {
    wrz = "wrz.one";
    helvetica = "helveticanonstandard.net";
  };
}
