{
  lib,
  inputs,
  ...
}:
{
  options.pubkeys =
    let
      inherit (lib) types;
    in
    lib.mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      description = ''
        Public keys.
      '';
      readOnly = true;
    };

  config.pubkeys = import (inputs.self + /pubkeys.nix);
}
