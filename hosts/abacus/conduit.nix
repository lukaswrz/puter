{
  config,
  pkgs,
  ...
}: let
  inherit (config.networking) domain;
  subdomain = "matrix";
  jsonFormat = pkgs.formats.json {};
  wellKnownServer = jsonFormat.generate "well-known-matrix-server" {
    "m.server" = "${subdomain}.${domain}:443";
  };
  wellKnownClient = jsonFormat.generate "well-known-matrix-client" {
    "m.homeserver".base_url = "https://${subdomain}.${domain}";
  };
in {
  services.matrix-conduit = {
    enable = true;

    settings.global = {
      server_name = domain;

      address = "127.0.0.1";
      port = 8010;

      database_backend = "rocksdb";

      allow_registration = false;
    };
  };

  systemd.services.conduit.serviceConfig.LimitNOFILE = 8192;

  services.nginx.virtualHosts = {
    ${domain}.locations = {
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

    "${subdomain}.${domain}" = {
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
