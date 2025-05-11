{
  config,
  lib,
  pkgs,
  ...
}:
let
  virtualHostName = "forgejo.helveticanonstandard.net";
in
{
  age.secrets = lib.mkSecrets {
    forgejo-mailer = {
      mode = "400";
      owner = "forgejo";
    };
    forgejo-admin = {
      mode = "400";
      owner = "forgejo";
    };
  };

  services.forgejo = {
    enable = true;
    package = pkgs.forgejo;
    database.type = "postgres";
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = virtualHostName;
        ROOT_URL = "https://${virtualHostName}/";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 8060;
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
        FROM = "tea@wrz.one";
        USER = "lukas@wrz.one";
      };
    };

    secrets.mailer.PASSWD = config.age.secrets.forgejo-mailer.path;
  };

  # TODO what
  systemd.services.forgejo.preStart = lib.getExe pkgs.writeShellApplication {
    name = "forgejo-init-admin";
    runtimeInputs = [
      config.services.forgejo.package
    ];
    text =
      let
        passwordFile = config.age.secrets.forgejo-admin.path;
      in
      ''
        admins=$(admin user list --admin)
        admins=$((admins - 1))

        if ((admins < 1)); then
          gitea admin user create \
            --admin \
            --email helvetica@helveticanonstandard.net \
            --username helvetica \
            --password "$(cat -- ${passwordFile})"
        fi
      '';
  };

  services.nginx.virtualHosts.${virtualHostName} = {
    enableACME = true;
    forceSSL = true;

    extraConfig = ''
      client_max_body_size 512M;
    '';

    locations."/".proxyPass =
      let
        host = config.services.forgejo.settings.server.HTTP_ADDR;
        port = builtins.toString config.services.forgejo.settings.server.HTTP_PORT;
      in
      "http://${host}:${port}";
  };
}
