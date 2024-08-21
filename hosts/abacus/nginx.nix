{
  config,
  ...
}: {
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    commonHttpConfig = ''
      error_log stderr;
      access_log /var/log/nginx/access.log;
    '';

    virtualHosts = let
      inherit (config.networking) domain;
    in {
      "~.*" = {
        default = true;

        globalRedirect = domain;
      };

      ${domain} = {
        enableACME = true;
        forceSSL = true;

        root = "/var/www/${domain}";
      };

      "log.${domain}" = {
        enableACME = true;
        forceSSL = true;

        root = "/var/www/log.${domain}";
      };
    };
  };
}
