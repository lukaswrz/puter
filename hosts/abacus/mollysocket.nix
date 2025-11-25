{ config, inputs, ... }:
{
  age.secrets.mollysocket.file = inputs.self + /secrets/mollysocket.age;

  services.mollysocket = {
    enable = true;

    settings = {
      # host = "localhost";
      host = "abacus.tailnet.helveticanonstandard.net";
      port = 6020;
      webserver = false;
      allowed_uuids = [ ];
      allowed_endpoints = [
        "https://poke.helveticanonstandard.net"
      ];
    };

    environmentFile = config.age.secrets.mollysocket.path;
  };

  # services.nginx.virtualHosts."mollysocket.helveticanonstandard.net" = {
  #   enableACME = true;
  #   forceSSL = true;

  #   locations."/" = {
  #     proxyPass =
  #       let
  #         inherit (config.services.mollysocket.settings) host port;
  #       in
  #       "http://${host}:${port}";
  #     proxyWebsockets = true;
  #   };
  # };
}
