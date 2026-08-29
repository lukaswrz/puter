{
  secretsPath,
  config,
  lib,
  pkgs,
  ...
}:
let
  proxyHost = config.proxyHosts.forgejo;
  cfg = config.services.forgejo;
  inherit (config.age) secrets;
in
{
  age.secrets = {
    forgejo-mailer = {
      file = secretsPath + /forgejo/mailer.age;
      owner = cfg.user;
    };

    forgejo-admin = {
      file = secretsPath + /forgejo/admin.age;
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
      DEFAULT = {
        APP_NAME = "hack.moontide.ink";
        APP_SLOGAN = "";
        APP_DISPLAY_NAME_FORMAT = "{APP_NAME}";
      };

      ui = {
        DEFAULT_THEME = "gitea-auto";
      };

      "ui.meta" = {
        AUTHOR = "Lukas Wurzinger";
        DESCRIPTION = "hack.moontide.ink Forgejo instance";
        KEYWORDS = "code,forge";
      };

      server = {
        DOMAIN = proxyHost.virtualHostName;
        ROOT_URL = "https://${proxyHost.virtualHostName}/";
        HTTP_ADDR = proxyHost.host;
        HTTP_PORT = proxyHost.port;

        LANDING_PAGE = "explore";
      };

      service = {
        DISABLE_REGISTRATION = true;
        ENABLE_NOTIFY_MAIL = true;
      };

      # TODO: Enable when federation is done
      federation = {
        ENABLED = false;
        SHARE_USER_STATISTICS = false;
      };

      mailer = {
        ENABLED = true;
        FROM = "hack@moontide.ink";
        PROTOCOL = "smtps";
        SMTP_ADDR = "smtp.fastmail.com";
        SMTP_PORT = 465;
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
              --email lukas@wrz.one \
              --username lukas \
              --password "$(cat -- ${passwordFile})"
          fi
        '';
    }
  );

  services.nginx.virtualHosts.${proxyHost.virtualHostName} = {
    enableACME = true;
    forceSSL = true;

    extraConfig = ''
      client_max_body_size 512M;
    '';

    locations."/".proxyPass = "http://${proxyHost.address}";
  };
}
