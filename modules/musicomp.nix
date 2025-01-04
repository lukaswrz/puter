{
  self,
  lib,
  pkgs,
  utils,
  config,
  ...
}: let
  inherit (lib) types;
  inherit (utils.systemdUtils.unitOptions) unitOption;
in {
  options.services.musicomp.jobs = lib.mkOption {
    description = ''
      Compression jobs to run with musicomp.
    '';
    default = {};
    # type = types.attrsOf (types.submodule ({name, ...}: {
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
            Number of workers.
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
    systemd.services =
      lib.mapAttrs'
      (
        name: job:
          lib.nameValuePair "musicomp-jobs-${name}" {
            wantedBy = ["multi-user.target"];
            restartIfChanged = false;

            script = ''
              ${lib.optionalString job.inhibitsSleep ''
                ${lib.getExe' pkgs.systemd "systemd-inhibit"} \
                  --mode block \
                  --who musicomp \
                  --what sleep \
                  --why ${lib.escapeShellArg "Scheduled musicomp ${name}"}
              ''}

              ${lib.getExe job.package} \
                ${lib.optionalString (job.workers > 0) "--workers ${job.workers}"} \
                -- ${job.music} ${job.comp}
            '';

            postStop = job.post;

            serviceConfig.Type = "oneshot";
          }
      )
      config.services.musicomp.jobs;

    systemd.timers =
      lib.mapAttrs'
      (name: job:
        lib.nameValuePair "musicomp-jobs-${name}" {
          wantedBy = ["timers.target"];
          inherit (job) timerConfig;
        })
      (lib.filterAttrs (_: job: job.timerConfig != null) config.services.musicomp.jobs);
  };
}
