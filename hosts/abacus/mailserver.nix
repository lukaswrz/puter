{
  config,
  pkgs,
  secretsPath,
  ...
}:
let
  inherit (config.networking) fqdn;
in
{
  age.secrets = {
    mail-m64.file = secretsPath + /mail/m64.age;
    # mail-lukas.file = secretsPath + /users/mail/lukas.age;
    # mail-helvetica.file = secretsPath + /users/mail/helvetica.age;

    mail-vault.file = secretsPath + /users/mail/vault.age;
    mail-forge.file = secretsPath + /users/mail/forge.age;
  };

  # environment.persistence."/persist".directories = [
  #   config.mailserver.dkimKeyDirectory
  #   config.mailserver.mailDirectory
  #   config.mailserver.sieveDirectory
  # ];

  mailserver = {
    enable = true;
    openFirewall = true;
    inherit fqdn;
    domains = [
      "moontide.ink"
      "wrz.one"
      "helveticanonstandard.net"
    ];
    x509.useACMEHost = config.mailserver.fqdn;
    stateVersion = 3;

    loginAccounts = {
      "m64@moontide.ink" = {
        hashedPasswordFile = config.age.secrets.mail-m64.path;

        aliases = [
          "lukas@moontide.ink"
          "postmaster@moontide.ink"

          "lukas@wrz.one"
          "postmaster@wrz.one"

          "helvetica@helveticanonstandard.net"
          "postmaster@helveticanonstandard.net"
        ];
      };

      "vault@moontide.ink".hashedPasswordFile = config.age.secrets.mail-vault.path;
      "forge@moontide.ink".hashedPasswordFile = config.age.secrets.mail-forge.path;
    };
  };

  services.nginx.virtualHosts = {
    ${config.mailserver.fqdn} = {
      enableACME = true;
      forceSSL = true;

      globalRedirect = "moontide.ink";
    };

    "mta-sts.moontide.ink" = {
      enableACME = true;
      forceSSL = true;

      locations = {
        "/".return = "404";

        "=/.well-known/mta-sts.txt" = {
          alias = pkgs.writeText "mta-sts.txt" ''
            version: STSv1
            mode: enforce
            mx: ${fqdn}
            max_age: 86400
          '';

          extraConfig = ''
            default_type text/plain;
          '';
        };
      };
    };
  };
}
