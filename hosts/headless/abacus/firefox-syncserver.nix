# TODO: do this via tailscale?
# {
#   config,
#   lib,
#   pkgs,
#   ...
# }: let
#   virtualHostName = "syncserver.helveticanonstandard.net";
# in {
#   age.secrets = lib.mkSecrets {syncserver = {};};
#
#   services.firefox-syncserver = {
#     enable = true;
#     secrets = config.age.secrets.syncserver.path;
#     singleNode = {
#       enable = true;
#       hostname = virtualHostName;
#       url = "https://${virtualHostName}";
#     };
#     settings = {
#       port = 8070;
#     };
#   };
#
#   services.nginx.virtualHosts.${config.services.firefox-syncserver.singleNode.hostname} = {
#     enableACME = true;
#     forceSSL = true;
#
#     locations."/".proxyPass = let
#       host = "127.0.0.1";
#       port = builtins.toString config.services.firefox-syncserver.settings.port;
#     in "http://${host}:${port}";
#   };
#
#   services.mysql.package = pkgs.mariadb;
# }
{}
