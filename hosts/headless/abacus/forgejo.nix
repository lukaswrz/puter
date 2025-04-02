{
  config,
  lib,
  ...
}: let
  virtualHostName = "forgejo.helveticanonstandard.net";
in {
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

  systemd.services.forgejo.preStart = let
    forgejo = lib.getExe config.services.forgejo.package;
    passwordFile = config.age.secrets.forgejo-admin.path;
    user = "helvetica";
    email = "helvetica@helveticanonstandard.net";
  in ''
    if ! \
      ${forgejo} admin user change-password \
        --username ${lib.escapeShellArg user} \
        --password "$(cat -- ${lib.escapeShellArg passwordFile})"
    then
      ${forgejo} admin user create \
        --admin \
        --email ${lib.escapeShellArg email} \
        --username ${lib.escapeShellArg user} \
        --password "$(cat -- ${lib.escapeShellArg passwordFile})"
    fi
  '';

  services.nginx.virtualHosts.${virtualHostName} = {
    enableACME = true;
    forceSSL = true;

    extraConfig = ''
      client_max_body_size 512M;
    '';

    locations."/".proxyPass = let
      host = config.services.forgejo.settings.server.HTTP_ADDR;
      port = builtins.toString config.services.forgejo.settings.server.HTTP_PORT;
    in "http://${host}:${port}";
  };
}
