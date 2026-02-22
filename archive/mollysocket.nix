{
  lib,
  config,
  inputs,
  ...
}:
let
  tailnet = "tailnet.moontide.ink";
in
{
  age.secrets.mollysocket.file = inputs.self + /secrets/mollysocket.age;

  services.mollysocket = {
    enable = true;

    settings = {
      host = "abacus.${tailnet}";
      webserver = false;
      allowed_uuids = [
        "7b30192b-2220-4ea3-9570-87251cb3148e"
      ];
      allowed_endpoints = [
        "https://poke.helveticanonstandard.net"
      ];
    };

    environmentFile = config.age.secrets.mollysocket.path;
  };

  systemd.services.mollysocket.serviceConfig.WorkingDirectory =
    lib.mkForce "/var/lib/private/mollysocket";
  systemd.services.mollysocket.serviceConfig.ProtectSystem = lib.mkForce "full";
}
