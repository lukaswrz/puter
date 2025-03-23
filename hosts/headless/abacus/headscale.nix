# {config, ...}: let
#   virtualHostName = "";
# in {
#   services.headscale = {
#     enable = true;
#     address = "127.0.0.1";
#     port = 8070;
#     server_url = "https://${virtualHostName}";
#     settings = {
#       logtail.enabled = false;
#     };
#   };
#
#   services.nginx.virtualHosts.${virtualHostName} = {
#     forceSSL = true;
#     enableACME = true;
#     locations."/" = {
#       proxyPass = "http://localhost:${toString config.services.headscale.port}";
#       proxyWebsockets = true;
#     };
#   };
# }
{}
