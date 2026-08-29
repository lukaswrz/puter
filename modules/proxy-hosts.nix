{ lib, ... }:
let
  inherit (lib) types;
  ipv6Type = types.strMatching "(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))";
  ipv4Type = types.strMatching "^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$";
in
{
  options.proxyHosts = lib.mkOption {
    type = types.attrsOf (
      types.submodule (
        { name, config, ... }: {
          options = {
            virtualHostName = lib.mkOption {
              type = types.str;
              description = "The virtual host name.";
            };

            host = lib.mkOption {
              type = types.oneOf [
                ipv4Type
                ipv6Type
              ];
              default = "localhost";
              description = "The upstream host.";
            };

            port = lib.mkOption {
              type = types.port;
              description = "The upstream port.";
            };

            address = lib.mkOption {
              readOnly = true;
              default =
                if ipv4Type.check config.host then
                  "${config.host}:${config.port}"
                else if ipv6Type.check config.host then
                  "[${config.host}]:${config.port}"
                else
                  throw "Proxy host does not match IPv4 or IPv6 pattern";
            };
          };
        }
      )
    );

    description = ''
      Reverse proxy definitions.
    '';
  };
}
