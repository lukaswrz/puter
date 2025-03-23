{config, ...}: let
  virtualHostName = "grafana.helveticanonstandard.net";
in {
  services.grafana = {
    enable = true;

    settings = {
      server = {
        domain = virtualHostName;
        http_port = 9010;
        http_addr = "127.0.0.1";
        root_url = "http://192.168.1.10:8010"; # TODO
        protocol = "http";
      };

      analytics.reporting_enabled = false;
    };

    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          url = "http://127.0.0.1:${builtins.toString config.services.prometheus.port}";
        }
        {
          name = "Loki";
          type = "loki";
          access = "proxy";
          url = "http://127.0.0.1:${builtins.toString config.services.loki.configuration.server.http_listen_port}";
        }
      ];
    };
  };

  # services.nginx.virtualHosts.${virtualHostName} = {
  #   locations."/" = {
  #     proxyPass = let
  #       host = config.services.grafana.settings.server.http_addr;
  #       port = builtins.toString config.services.grafana.settings.server.http_port;
  #     in "http://${host}:${port}";
  #     proxyWebsockets = true;
  #   };
  # };
}
