{
  config,
  lib,
  ...
}: let
  inherit (config.networking) domain;
  virtualHostName = "tea.${domain}";
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
        REQUIRE_SIGNIN_VIEW = true; # TODO
      };

      federation = {
        ENABLED = false; # TODO
        SHARE_USER_STATISTICS = false; # TODO
      };

      mailer = {
        ENABLED = true;
        SMTP_ADDR = "smtp.fastmail.com";
        FROM = "tea@${domain}";
        USER = "lukas@${domain}";
      };
    };
    secrets.mailer.PASSWD = config.age.secrets.forgejo-mailer.path;
  };

  systemd.services.forgejo.preStart = let
    forgejo = lib.getExe config.services.forgejo.package;
    passwordFile = config.age.secrets.forgejo-admin.path;
    user = "lukas";
    email = "lukas@wrz.one";
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
      inherit (config.services.forgejo.settings.server) HTTP_ADDR HTTP_PORT;
    in "http://${lib.formatHostPort {
      host = HTTP_ADDR;
      port = HTTP_PORT;
    }}";
  };
}
