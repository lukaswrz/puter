{config, ...}: {
  services.nginx = {
    virtualHosts = let
      inherit (config.networking) domain;
    in {
      ${domain} = {
        root = "/var/www/${domain}";
        enableACME = true;
        forceSSL = true;
        quic = true;
      };
      "log.${domain}" = {
        root = "/var/www/log.${domain}";
        enableACME = true;
        forceSSL = true;
        quic = true;
      };
    };
  };
}
