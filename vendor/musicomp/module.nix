self: {
  lib,
  pkgs,
  utils,
  config,
  ...
}: let
  cfg = config.services.musicomp;
  inherit (lib) types;
  inherit (utils.systemdUtils.unitOptions) unitOption;
in {
  options.services.musicomp.jobs = lib.mkOption {
    description = ''
      Compression jobs to run with musicomp.
    '';
    default = {};
    type = types.attrsOf (types.submodule {
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

        package = lib.mkPackageOption self.packages.${pkgs.system} "musicomp" {};

        inhibitsSleep = lib.mkOption {
          default = false;
          type = lib.types.bool;
          example = true;
          description = ''
            Prevents the system from sleeping while running the job.
          '';
        };
      };
    });
  };

  config = {
    systemd = lib.mkMerge (
      lib.mapAttrsToList (
        jobName: job:
        let
          systemdName = "musicomp-job-${jobName}";
          description = "musicomp job ${jobName}";
        in
        {
          timers.${systemdName} = {
            wantedBy = [ "timers.target" ];
            inherit description;
            inherit (job) timerConfig;
          };

          services.${systemdName} = {
            inherit description;

            serviceConfig = {
              Type = "oneshot";
              User = "root";
              Group = "root";
            };

            script = ''
                ${lib.optionalString job.inhibitsSleep ''
                  ${lib.getExe' config.systemd.package "systemd-inhibit"} \
                    --mode block \
                    --who ${lib.escapeShellArg systemdName} \
                    --what sleep \
                    --why ${lib.escapeShellArg "Scheduled musicomp job ${jobName}"}
                ''}

                ${lib.getExe job.package} \
                  ${lib.optionalString (job.workers > 0) "--workers ${lib.escapeShellArg job.workers}"} \
                  --verbose \
                  -- ${lib.escapeShellArg job.music} ${lib.escapeShellArg job.comp}
              '';

            postStart = job.post;
          };
        }
      ) cfg.jobs
    );
  };
}
