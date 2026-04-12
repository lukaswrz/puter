{
  config,
  pkgs,
  secretsPath,
  ...
}:
let
  inherit (config.networking) domain fqdn;
in
{
  age.secrets = {
    mail-helvetica.file = secretsPath + /mail/helvetica.age;

    mail-vault.file = secretsPath + /mail/vault.age;
    mail-forge.file = secretsPath + /mail/forge.age;
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
    ];
    x509.useACMEHost = config.mailserver.fqdn;
    stateVersion = 3;

    accounts = {
      "helvetica@moontide.ink" = {
        hashedPasswordFile = config.age.secrets.mail-helvetica.path;

        aliases = [
          "lukas@moontide.ink"
          "postmaster@moontide.ink"

          "lukas@wrz.one"
          "postmaster@wrz.one"
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

      globalRedirect = domain;
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
