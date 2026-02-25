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
      # "wrz.one"
      # "helveticanonstandard.net"
    ];
    x509.useACMEHost = config.mailserver.fqdn;
    stateVersion = 3;

    loginAccounts = {
      "m64@moontide.ink" = {
        hashedPasswordFile = config.age.secrets.mail-m64.path;
        aliases = [
          "lukas@moontide.ink"
          "postmaster@moontide.ink"
        ];
      };

      # "vault@moontide.ink".hashedPasswordFile = config.age.secrets.mail-vault.path;
      # "forge@moontide.ink".hashedPasswordFile = config.age.secrets.mail-forge.path;

      # "lukas@wrz.one" = {
      #   hashedPasswordFile = config.age.secrets.mail-lukas.path;
      #   aliases = ["postmaster@wrz.one"];
      # };

      # "helvetica@helveticanonstandard.net" = {
      #   hashedPasswordFile = config.age.secrets.mail-lukas.path;
      #   aliases = ["postmaster@helveticanonstandard.net"];
      # };
    };
  };

  services.nginx.virtualHosts = {
    "abacus.moontide.ink" = {
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
