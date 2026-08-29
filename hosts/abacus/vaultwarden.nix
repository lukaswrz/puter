{
  config,
  secretsPath,
  ...
}:
let
  proxyHost = config.proxyHosts.vaultwarden;
in
{
  age.secrets.vaultwarden.file = secretsPath + /vaultwarden.age;

  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    backupDir = "/srv/backup/vaultwarden";

    config = {
      ROCKET_ADDRESS = proxyHost.host;
      ROCKET_PORT = proxyHost.port;
      ENABLE_WEBSOCKET = true;
      DOMAIN = "https://${proxyHost.virtualHostName}";

      SIGNUPS_ALLOWED = false;
      INVITATIONS_ALLOWED = false;

      SMTP_HOST = "smtp.fastmail.com";
      SMTP_FROM = "vault@moontide.ink";
      SMTP_FROM_NAME = "Vaultwarden";
      SMTP_USERNAME = "lukas@wrz.one";
      SMTP_TIMEOUT = 15;
      SMTP_SECURITY = "force_tls";
      SMTP_PORT = 465;
    };

    environmentFile = config.age.secrets.vaultwarden.path;
  };

  systemd.timers.backup-vaultwarden.timerConfig.OnCalendar = "*-*-* 02:00:00";

  services.nginx.virtualHosts.${proxyHost.virtualHostName} = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://${proxyHost.address}";
      proxyWebsockets = true;
    };
  };
}
