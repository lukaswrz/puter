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
      INVITATIONS_ALLOWED = true;
      INVITATION_ORG_NAME = domain;

      SMTP_HOST = config.mailserver.fqdn;
      SMTP_PORT = 587;
      SMTP_SECURITY = "force_tls";
      SMTP_TIMEOUT = 15;

      SMTP_FROM = "vault@${domain}";
      SMTP_FROM_NAME = "Vaultwarden";

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
