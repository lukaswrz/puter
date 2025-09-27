self:
{
  lib,
  pkgs,
  utils,
  config,
  ...
}:
let
  cfg = config.services.musicomp;
  inherit (lib) types;
  inherit (utils.systemdUtils.unitOptions) unitOption;
in
{
  options.services.musicomp = {
    enable = lib.mkEnableOption "musicomp";

    package = lib.mkPackageOption self.packages.${pkgs.system} "default" { };

    jobs = lib.mkOption {
      description = ''
        Compression jobs to run with musicomp.
      '';
      default = { };
      type = types.attrsOf (
        types.submodule {
          options = {
            music = lib.mkOption {
              type = types.str;
              description = ''
                Source directory.
              '';
              example = "/srv/music";
            };

            comp = lib.mkOption {
              type = types.str;
              description = ''
                Destination directory for compressed music.
              '';
              example = "/srv/comp";
            };

            post = lib.mkOption {
              type = types.lines;
              default = "";
              description = ''
                Shell commands that are run after compression has finished.
              '';
            };

            workers = lib.mkOption {
              type = lib.types.int;
              default = 0;
              description = ''
                Number of workers. A number less than 1 means that musicomp will use the amount of available processor threads.
              '';
            };

            timerConfig = lib.mkOption {
              type = lib.types.nullOr (lib.types.attrsOf unitOption);
              default = {
                OnCalendar = "daily";
                Persistent = true;
              };
              description = ''
                When to run the job.
              '';
            };

            inhibit = lib.mkOption {
              default = [ ];
              type = types.listOf (types.strMatching "^[^:]+$");
              example = [
                "sleep"
              ];
              description = ''
                Run the musicomp process with an inhibition lock taken;
                see {manpage}`systemd-inhibit(1)` for a list of possible operations.
              '';
            };
          };
        }
      );
    };
  };

  config = {
    systemd = lib.mkMerge (
      lib.mapAttrsToList (
        jobName: job:
        let
          unitName = "musicomp-job-${jobName}";
          description = "musicomp job ${jobName}";
        in
        {
          timers.${unitName} = {
            wantedBy = [ "timers.target" ];
            inherit description;
            inherit (job) timerConfig;
          };

          services.${unitName} = {
            inherit description;

            serviceConfig = {
              Type = "oneshot";
              User = "root";
              Group = "root";

              ExecStart =
                let
                  inhibitArgs = [
                    (lib.getExe' config.systemd.package "systemd-inhibit")
                    "--mode"
                    "block"
                    "--who"
                    description
                    "--what"
                    (lib.concatStringsSep ":" job.inhibit)
                    "--why"
                    "Scheduled musicomp job ${jobName}"
                    "--"
                  ];

                  args =
                    (lib.optionals (job.inhibit != [ ]) inhibitArgs)
                    ++ [ (lib.getExe cfg.package) ]
                    ++ lib.optional (job.workers > 0) "--workers ${lib.escapeShellArg job.workers}"
                    ++ [
                      "--verbose"
                      "--"
                      job.music
                      job.comp
                    ];
                in
                utils.escapeSystemdExecArgs args;
            };

            postStart = job.post;
          };
        }
      ) cfg.jobs
    );
  };
}
