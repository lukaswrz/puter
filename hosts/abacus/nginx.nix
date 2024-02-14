{
  config,
  pkgs,
  ...
}: {
  environment.persistence."/persist".directories = ["/var/www"];

  services.nginx = {
    enable = true;
    package = pkgs.nginxQuic;

    recommendedBrotliSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedZstdSettings = true;
    commonHttpConfig = ''
      error_log stderr;
      access_log /var/log/nginx/access.log;
    '';

    virtualHosts = let
      inherit (config.networking) domain;
    in {
      "~.*" = {
        default = true;
        rejectSSL = true;

        globalRedirect = domain;
      };

      ${domain} = {
        enableACME = true;
        forceSSL = true;
        quic = true;

        root = "/var/www/${domain}";
      };

      "log.${domain}" = {
        enableACME = true;
        forceSSL = true;
        quic = true;

        root = "/var/www/log.${domain}";
      };
    };
  };
}
