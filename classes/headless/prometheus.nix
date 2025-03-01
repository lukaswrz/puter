{
  config,
  lib,
  ...
}: {
  services.prometheus = {
    enable = true;
    port = 3020;

    exporters = {
      node = {
        enable = true;
        port = 3021;
        enabledCollectors = ["systemd"];
      };
    };

    scrapeConfigs = [
      {
        job_name = "nodes";
        static_configs = [
          {
            targets = let
              target = lib.formatHostPort {
                host = config.services.prometheus.exporters.node.listenAddr;
                inherit (config.services.prometheus.exporters.node) port;
              };
            in [target];
          }
        ];
      }
    ];
  };
}
