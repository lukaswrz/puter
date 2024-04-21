{config, ...}: let
  inherit (config.networking) domain;
  virtualHostName = "vault.${domain}";
in {
  age.secrets.vaultwarden = {
    file = ../../secrets/vaultwarden.age;
    owner = config.systemd.services.vaultwarden.serviceConfig.User;
    group = config.systemd.services.vaultwarden.serviceConfig.Group;
  };

  services.vaultwarden = {
    enable = true;

    config = {
      DOMAIN = "https://${virtualHostName}";

      SIGNUPS_ALLOWED = false;
      INVITATIONS_ALLOWED = false;

      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8000;
    };

    environmentFile = config.age.secrets.vaultwarden.path;
  };

  services.nginx.virtualHosts.${virtualHostName} = {
    enableACME = true;
    forceSSL = true;
    quic = true;

    locations."/" = {
      proxyPass = "http://${config.services.vaultwarden.config.ROCKET_ADDRESS}:${builtins.toString config.services.vaultwarden.config.ROCKET_PORT}";
      proxyWebsockets = true;
    };
  };
}
