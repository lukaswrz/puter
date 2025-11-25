{
  config,
  inputs,
  pkgs,
  ...
}:
let
  serverName = "helveticanonstandard.net";
  fqdn = "matrix.${serverName}";
  jsonFormat = pkgs.formats.json { };
  wellKnownServer = jsonFormat.generate "well-known-matrix-server" {
    "m.server" = "${fqdn}:443";
  };
  wellKnownClient = jsonFormat.generate "well-known-matrix-client" {
    "m.homeserver".base_url = "https://${fqdn}";
  };
in
{
  age.secrets.matrix-register.file = inputs.self + /secrets/matrix/register.age;

  services.matrix-continuwuity = {
    enable = true;

    settings.global = {
      server_name = serverName;

      address = "localhost";
      port = 8030;

      trusted_servers = [ "matrix.org" ];

      allow_registration = false;
      registration_token_file = config.age.secrets.matrix-register.path;
      allow_federation = true;
      allow_encryption = true;
    };
  };

  services.nginx.virtualHosts = {
    ${serverName}.locations = {
      "=/.well-known/matrix/server" = {
        alias = wellKnownServer;

        extraConfig = ''
          default_type application/json;
          add_header Access-Control-Allow-Origin "*";
        '';
      };

      "=/.well-known/matrix/client" = {
        alias = wellKnownClient;

        extraConfig = ''
          default_type application/json;
          add_header Access-Control-Allow-Origin "*";
        '';
      };
    };

    ${fqdn} = {
      enableACME = true;
      forceSSL = true;
      quic = true;

      locations = {
        "/".return = "404";

        "/_matrix/" = {
          proxyPass = "http://${config.services.matrix-conduit.settings.global.address}:${toString config.services.matrix-conduit.settings.global.port}";
          proxyWebsockets = true;

          extraConfig = ''
            proxy_buffering off;
          '';
        };
      };

      extraConfig = ''
        merge_slashes off;
      '';
    };
  };
}
