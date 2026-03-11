{
  config,
  secretsPath,
  ...
}:
let
  virtualHostName = "vault.moontide.ink";
in
{
  age.secrets.vaultwarden.file = secretsPath + /vaultwarden.age;

  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    backupDir = "/srv/backup/vaultwarden";

    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8010;
      ENABLE_WEBSOCKET = true;
      DOMAIN = "https://${virtualHostName}";

      SIGNUPS_ALLOWED = false;
      INVITATIONS_ALLOWED = false;

      SMTP_HOST = "abacus.moontide.ink";
      SMTP_FROM = "vault@moontide.ink";
      SMTP_FROM_NAME = "Vaultwarden";
      SMTP_USERNAME = "forge@moontide.ink";
      SMTP_TIMEOUT = 15;
      SMTP_SECURITY = "force_tls";
      SMTP_PORT = 465;
    };

    environmentFile = config.age.secrets.vaultwarden.path;
  };

  systemd.timers.backup-vaultwarden.timerConfig.OnCalendar = "*-*-* 02:00:00";

  services.nginx.virtualHosts.${virtualHostName} = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass =
        let
          host = config.services.vaultwarden.config.ROCKET_ADDRESS;
          port = builtins.toString config.services.vaultwarden.config.ROCKET_PORT;
        in
        "http://${host}:${port}";
      proxyWebsockets = true;
    };
  };
}
