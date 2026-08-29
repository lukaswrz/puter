{
  config,
  secretsPath,
  pkgs,
  ...
}:
let
  proxyHost = config.proxyHosts.continuwuity;
  serverName = "moontide.ink";
  jsonFormat = pkgs.formats.json { };
  wellKnownServer = jsonFormat.generate "well-known-matrix-server" {
    "m.server" = "${proxyHost.virtualHostName}:443";
  };
  wellKnownClient = jsonFormat.generate "well-known-matrix-client" {
    "m.homeserver".base_url = "https://${proxyHost.virtualHostName}";
  };
in
{
  age.secrets.matrix-register = {
    file = secretsPath + /matrix/register.age;
    owner = config.services.matrix-continuwuity.user;
  };

  services.matrix-continuwuity = {
    enable = true;

    settings.global = {
      server_name = serverName;

      address = [ proxyHost.host ];
      port = [ proxyHost.port ];

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

    ${proxyHost.virtualHostName} = {
      enableACME = true;
      forceSSL = true;

      locations = {
        "/".return = "404";

        "/_matrix/" = {
          proxyPass = "http://${proxyHost.address}";
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
