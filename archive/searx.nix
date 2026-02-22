{ config, ... }:
let
  virtualHostName = "search.helveticanonstandard.net";
in
{
  # TODO: authelia

  services.searx = {
    enable = true;
    settings = {
      use_default_settings = true;
      server.base_url = "https://${virtualHostName}/";
    };
  };

  services.uwsgi = {
    enable = true;
    plugins = [ "python3" ];
    instance.type = "emperor";
    instance.vassals.searx = {
      type = "normal";
      strict = true;
      immediate-uid = "searx";
      immediate-gid = "searx";
      lazy-apps = true;
      enable-threads = true;
      module = "searx.webapp";
      env = [
        "SEARXNG_SETTINGS_PATH=${config.services.searx.settingsFile}"
      ];
      buffer-size = 32768;
      pythonPackages = _: [ config.services.searx.package ];
      socket = "/run/searx/uwsgi.sock";
      chmod-socket = "660";
    };
  };

  services.nginx.virtualHosts.${virtualHostName} = {
    enableACME = true;
    forceSSL = true;

    locations = {
      "/" = {
        recommendedUwsgiSettings = true;
        uwsgiPass = "unix:${config.services.uwsgi.instance.vassals.searx.socket}";
        extraConfig = # nginx
          ''
            uwsgi_param  HTTP_HOST $host;
            uwsgi_param  HTTP_CONNECTION $http_connection;
            uwsgi_param  HTTP_X_SCHEME $scheme;
            uwsgi_param  HTTP_X_SCRIPT_NAME "";
            uwsgi_param  HTTP_X_REAL_IP $remote_addr;
            uwsgi_param  HTTP_X_FORWARDED_FOR $proxy_add_x_forwarded_for;
          '';
      };

      "/static/".alias = "${config.services.searx.package}/share/static/";
    };
  };
}
