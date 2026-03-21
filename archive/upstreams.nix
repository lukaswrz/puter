{
  lib,
  ...
}:
{
  options.upstreams =
    let
      inherit (lib) types;
    in
    lib.mkOption {
      description = ''
        Upstreams.
      '';
      default = { };
      type = types.attrsOf (
        types.submodule (
          { name, config, ... }:
          {
            options = {
              host = lib.mkOption {
                type = types.str;
                readOnly = true;
                description = ''
                  Host of the upstream.
                '';
              };

              port = lib.mkOption {
                type = types.int;
                readOnly = true;
                default = null;
                description = ''
                  Port of the upstream.
                '';
              };

              address = lib.mkOption {
                type = types.str;
                readOnly = true;
                default = "${config.host}:${toString config.port}";
                defaultText = ''
                  The full address.
                '';
                description = ''
                  TODO
                '';
              };
            };
          }
        )
      );
    };
}
