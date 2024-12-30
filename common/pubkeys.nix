{
  lib,
  self,
  ...
}: {
  options.pubkeys = let
    inherit (lib) types;
  in
    lib.mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      description = ''
        Public keys.
      '';
    };

  config.pubkeys = import self + /pubkeys.nix;
}