{config, ...}: let
  inherit (config.networking) domain;
  virtualHostName = "log.${domain}";
  root = "/var/www/${virtualHostName}";
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
