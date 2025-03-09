{
  config,
  lib,
  ...
}: {
  services.grafana = {
    enable = true;

    settings.server = {
      domain = "grafana.pele";
      http_port = 9010;
      http_addr = "127.0.0.1";
      root_url = "http://192.168.1.10:8010"; # TODO
      protocol = "http";
    };

    analytics.reporting.enable = false;

    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          url = "http://127.0.0.1:${toString config.services.prometheus.port}";
        }
        {
          name = "Loki";
          type = "loki";
          access = "proxy";
          url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
        }
      ];
    };
  };

  services.nginx.virtualHosts.${config.services.grafana.settings.server.domain} = {
    locations."/" = {
      proxyPass = "http://${lib.formatHostPort {
        host = config.services.grafana.settings.server.http_addr;
        port = config.services.grafana.settings.server.http_port;
      }}";
      proxyWebsockets = true;
    };
  };
}
