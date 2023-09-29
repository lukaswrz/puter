{config, ...}: {
  services.vaultwarden = {
    enable = true;

    config = {
      SIGNUPS_ALLOWED = false;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8000;
    };
  };

  services.nginx.virtualHosts."vault.defenestrated.systems" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      recommendedProxySettings = true;
      proxyPass = "http://${config.services.vaultwarden.config.ROCKET_ADDRESS}:${builtins.toString config.services.vaultwarden.config.ROCKET_PORT}";
    };
  };
}
