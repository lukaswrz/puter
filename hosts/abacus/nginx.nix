{ config, ... }:
{
  services.nginx = {
    enable = true;

    recommendedBrotliSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    commonHttpConfig = ''
      error_log stderr;
      access_log /var/log/nginx/access.log;
    '';

    virtualHosts."~.*" = {
      default = true;
      # rejectSSL = true;

      globalRedirect = config.networking.domain;
    };
  };
}
