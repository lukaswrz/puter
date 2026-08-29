{ config, secretsPath, ... }:
let
  proxyHost = config.proxyHosts.searx;
in
{
  age.secrets.searx.file = secretsPath + /searx/searx.age;

  services.searx = {
    enable = true;
    redisCreateLocally = true;
    configureUwsgi = true;
    uwsgiConfig.http = "${proxyHost.address}";

    settings = {
      general = {
        debug = false;
        instance_name = proxyHost.virtualHostName;
        donation_url = false;
        contact_url = false;
        privacypolicy_url = false;
        enable_metrics = false;
      };

      ui = {
        query_in_title = true;
        infinite_scroll = false;
        search_on_category_select = true;
        hotkeys = "vim";
      };

      search = {
        safe_search = 2;
        autocomplete_min = 2;
        autocomplete = "duckduckgo";
      };

      server = {
        base_url = "https://${proxyHost.virtualHostName}";

        bind_address = "localhost";
        inherit (proxyHost) port;

        secret_key = config.age.secrets.searx.path;
        limiter = false;
        public_instance = true;
        image_proxy = true;
        method = "GET";
      };

      enabled_plugins = [
        "Basic Calculator"
        "Hash plugin"
        "Open Access DOI rewrite"
        "Hostnames plugin"
        "HTTPS rewrite"
        "Unit converter plugin"
        "Tracker URL remover"
        "Search operators"
      ];
    };
  };

  age.secrets.searx-htpasswd = {
    file = secretsPath + /searx/htpasswd.age;
    owner = config.services.nginx.user;
  };

  services.nginx.virtualHosts.${proxyHost.virtualHostName} = {
    enableACME = true;
    forceSSL = true;

    basicAuthFile = config.age.secrets.searx-htpasswd.path;

    locations."/".proxyPass = "http://${proxyHost.address}";
  };
}
