{config, ...}: let
  inherit (config.networking) domain;
  inherit (config.networking) fqdn;
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
        aliases = ["postmaster@${domain}"];
      };
    };

    certificateScheme = "acme-nginx";
  };

  # FIXME: This is unnecessary when https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/issues/275 is closed
  services.dovecot2.sieve.extensions = ["fileinto"];

  services.nginx.virtualHosts."mta-sts.${domain}" = {
    locations."= /.well-known/mta-sts.txt".return = ''200 "version: STSv1\nmode: enforce\nmx: ${fqdn}\nmax_age: 86400"'';
    enableACME = true;
    forceSSL = true;
    quic = true;
  };
}
