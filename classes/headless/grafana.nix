{
  services.grafana = {
    enable = true;
    domain = "grafana.pele";
    port = 9010;
    addr = "127.0.0.1";

    # WARNING: this should match nginx setup!
    # prevents "Request origin is not authorized"
    rootUrl = "http://192.168.1.10:8010"; # helps with nginx / ws / live

    protocol = "http";
    analytics.reporting.enable = false;

    provision = {
      enable = true;
      datasources = [
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

  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    locations."/" = {
      proxyPass = "http://${lib.formatHostPort {
        host = config.services.grafana.addr;
        inherit (config.services.grafana) port;
      }}";
      proxyWebsockets = true;
    };
  };
}
