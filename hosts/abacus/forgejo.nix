{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.forgejo;
  inherit (config.age) secrets;
in
{
  age.secrets = {
    forgejo-mailer = {
      file = inputs.self + /secrets/forgejo/mailer.age;
      mode = "400";
      owner = cfg.user;
    };

    forgejo-admin = {
      file = inputs.self + /secrets/forgejo/admin.age;
      mode = "400";
      owner = cfg.user;
    };
  };

  services.forgejo = {
    enable = true;
    package = pkgs.forgejo;
    database.type = "postgres";
    lfs.enable = true;
    dump = {
      enable = true;
      interval = "*-*-* 02:00:00";
      backupDir = "/srv/backup/forgejo";
    };
    settings = {
      server = {
        DOMAIN = "hack.helveticanonstandard.net";
        ROOT_URL = "https://${cfg.settings.server.DOMAIN}/";
        HTTP_ADDR = "localhost";
        HTTP_PORT = 8020;
      };

      service = {
        DISABLE_REGISTRATION = true;
        ENABLE_NOTIFY_MAIL = true;
      };

      # TODO: Enable
      federation = {
        ENABLED = false;
        SHARE_USER_STATISTICS = false;
      };

      mailer = {
        ENABLED = true;
        SMTP_ADDR = "smtp.fastmail.com";
        FROM = "forge@helveticanonstandard.net";
        USER = "lukas@wrz.one";
      };

      log.LEVEL = "Debug";
    };

    secrets.mailer.PASSWD = secrets.forgejo-mailer.path;
  };

  systemd.services.forgejo.preStart = lib.getExe (
    pkgs.writeShellApplication {
      name = "forgejo-init-admin";
      text =
        let
          forgejoExe = lib.getExe cfg.package;
          passwordFile = secrets.forgejo-admin.path;
        in
        ''
          admins=$(${forgejoExe} admin user list --admin | wc --lines)
          admins=$((admins - 1))

          if ((admins < 1)); then
            ${forgejoExe} admin user create \
              --admin \
              --email helvetica@helveticanonstandard.net \
              --username helvetica \
              --password "$(cat -- ${passwordFile})"
          fi
        '';
    }
  );

  services.nginx.virtualHosts.${cfg.settings.server.DOMAIN} = {
    enableACME = true;
    forceSSL = true;

    extraConfig = ''
      client_max_body_size 512M;
    '';

    locations."/".proxyPass =
      let
        host = cfg.settings.server.HTTP_ADDR;
        port = builtins.toString cfg.settings.server.HTTP_PORT;
      in
      "http://${host}:${port}";
  };
}
