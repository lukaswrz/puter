{
  config,
  lib,
  ...
}: let
  inherit (config.networking) domain;
  parent = "/var/www";
  sites = [
    domain
    "log.${domain}"
  ];
in
  lib.mkMerge (map (
      virtualHostName: let
        root = "${parent}/${virtualHostName}";
      in {
        services.nginx.virtualHosts.${virtualHostName} = {
          enableACME = true;
          forceSSL = true;

          inherit root;
        };

        systemd.tmpfiles.settings."10-static-sites".${root}.d = {
          user = "lukas";
          group = "users";
          mode = "0755";
        };
      }
    )
    sites)
