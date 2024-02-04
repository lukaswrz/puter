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
    commonHttpConfig = "access_log syslog:server=unix:/dev/log;";
  };
}
