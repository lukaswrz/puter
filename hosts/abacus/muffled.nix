{
  config,
  ...
}:
let
  proxyHost = config.proxyHosts.muffled;
in
{
  services.muffled = {
    enable = true;
    settings = {
      user = "lukaswrz";
      listen = proxyHost.address;
      log_level = "debug";
      interval = 600;
      listenbrainz_base_url = "https://api.listenbrainz.org/1";
    };
  };

  services.nginx.virtualHosts.${proxyHost.virtualHostName} = {
    enableACME = true;
    forceSSL = true;

    locations."/".proxyPass = "http://${proxyHost.address}";
  };
}
