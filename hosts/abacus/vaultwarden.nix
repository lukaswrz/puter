{
  config,
  inputs,
  ...
}:
let
  virtualHostName = "vault.helveticanonstandard.net";
in
{
  age.secrets.vaultwarden.file = inputs.self + /secrets/vaultwarden.age;

  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    backupDir = "/srv/backup/vaultwarden";

    config = {
      DOMAIN = "https://${virtualHostName}";
      SIGNUPS_ALLOWED = false;
      INVITATIONS_ALLOWED = false;
      ENABLE_WEBSOCKET = true;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8010;
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
