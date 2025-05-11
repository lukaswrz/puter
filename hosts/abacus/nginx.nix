{
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

    virtualHosts =
      let
        matchAll = ''~.*'';
        matchWww = ''~^www\.(?<domain>.+)$'';
      in
      {
        # Redirect anything that doesn't match any server name to networking.domain
        ${matchAll} = {
          default = true;
          rejectSSL = true;

          globalRedirect = "wrz.one";
        };
        # Redirect www to non-www
        ${matchWww}.globalRedirect = "$domain";
      };
  };
}
