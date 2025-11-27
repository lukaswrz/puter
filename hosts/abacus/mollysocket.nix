{ config, inputs, ... }:
{
  age.secrets.mollysocket.file = inputs.self + /secrets/mollysocket.age;

  services.mollysocket = {
    enable = true;

    settings = {
      host = "abacus.tailnet.helveticanonstandard.net";
      webserver = false;
      allowed_uuids = [ ];
      allowed_endpoints = [
        "https://poke.helveticanonstandard.net"
      ];
    };

    environmentFile = config.age.secrets.mollysocket.path;
  };
}
