{config, ...}: let
  inherit (config.networking) domain;
in {
  services.vaultwarden = {
    enable = true;

    config = {
      SIGNUPS_ALLOWED = false;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8000;
    };
  };

  services.nginx.virtualHosts."vault.${domain}" = {
    locations."/".proxyPass = "http://${config.services.vaultwarden.config.ROCKET_ADDRESS}:${builtins.toString config.services.vaultwarden.config.ROCKET_PORT}";
    enableACME = true;
    forceSSL = true;
    quic = true;
  };
}
