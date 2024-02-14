{
  config,
  pkgs,
  ...
}: let
  inherit (config.networking) domain fqdn;

  wellKnownMtaSts = pkgs.writeText "" ''
    version: STSv1
    mode: enforce
    mx: ${fqdn}
    max_age: 86400
  '';
in {
  age.secrets.mail-lukas.file = ../../secrets/mail-lukas.age;

  environment.persistence."/persist".directories = [
    config.mailserver.dkimKeyDirectory
    config.mailserver.mailDirectory
    config.mailserver.sieveDirectory
  ];

  mailserver = {
    enable = true;
    openFirewall = true;
    inherit fqdn;
    domains = [domain];

    loginAccounts = {
      "lukas@${domain}" = {
        hashedPasswordFile = config.age.secrets.mail-lukas.path;
        aliases = ["postmaster@${domain}" "vault@${domain}"];
      };
    };

    certificateScheme = "acme-nginx";
  };

  # FIXME: This is unnecessary when https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/issues/275 is closed
  services.dovecot2.sieve.extensions = ["fileinto"];

  services.nginx.virtualHosts."mta-sts.${domain}" = {
    enableACME = true;
    forceSSL = true;
    quic = true;

    locations = {
      "/".return = "404";

      "=/.well-known/mta-sts.txt" = {
        alias = wellKnownMtaSts;

        extraConfig = ''
          default_type text/plain;
        '';
      };
    };
  };
}
