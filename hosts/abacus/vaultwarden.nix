{config, ...}: let
  inherit (config.networking) domain;
  virtualHostName = "vault.${domain}";
  backupDir = "/srv/backup/vaultwarden";
in {
  age.secrets.vaultwarden = {
    file = ../../secrets/vaultwarden.age;
    owner = config.systemd.services.vaultwarden.serviceConfig.User;
    group = config.systemd.services.vaultwarden.serviceConfig.Group;
  };

  services.vaultwarden = {
    enable = true;

    dbBackend = "sqlite";

    inherit backupDir;

    config = {
      DOMAIN = "https://${virtualHostName}";

      SIGNUPS_ALLOWED = false;
      INVITATIONS_ALLOWED = false;

      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8000;
    };

    environmentFile = config.age.secrets.vaultwarden.path;
  };

  systemd.timers.backup-vaultwarden.timerConfig.OnCalendar = "*-*-* 02:00:00";

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
