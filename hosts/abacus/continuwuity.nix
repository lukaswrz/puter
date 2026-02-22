{
  config,
  secretsPath,
  pkgs,
  ...
}:
let
  listenAddress = "127.0.0.1";
  port = 8030;
  serverName = "moontide.ink";
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
  age.secrets.matrix-register = {
    file = secretsPath + /matrix/register.age;
    mode = "400";
    owner = config.services.matrix-continuwuity.user;
  };

  services.matrix-continuwuity = {
    enable = true;

    settings.global = {
      server_name = serverName;

      address = [ listenAddress ];
      port = [ port ];

      trusted_servers = [ "matrix.org" ];

      allow_registration = true;
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

      locations = {
        "/".return = "404";

        "/_matrix/" = {
          proxyPass = "http://${listenAddress}:${toString port}";
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
