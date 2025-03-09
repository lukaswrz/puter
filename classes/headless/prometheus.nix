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
        listenAddress = "127.0.0.1";
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
                host = config.services.prometheus.exporters.node.listenAddress;
                inherit (config.services.prometheus.exporters.node) port;
              };
            in [target];
          }
        ];
      }
    ];
  };
}
