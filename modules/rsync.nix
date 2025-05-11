{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.rsync;
  inherit (lib) types;
  inherit (utils.systemdUtils.unitOptions) unitOption;
  settingsToShell = lib.cli.toGNUCommandLineShell {
    mkOptionName = k: "--${k}";
  };
  settingsType =
    let
      simples = [
        types.bool
        types.str
        types.int
        types.float
      ];
    in
    types.attrsOf (
      types.oneOf (
        simples
        ++ [
          (types.listOf (types.oneOf simples))
        ]
      )
    );
in
{
  options.services.rsync = {
    enable = lib.mkEnableOption "periodic directory syncing via rsync";

    package = lib.mkPackageOption pkgs "rsync" { };

    # commonSettings = lib.mkOption {
    #   type = settingsType;
    #   default = { };
    #   example = {
    #     archive = true;
    #     update = true;
    #     delete = true;
    #     mkpath = true;
    #   };
    #   description = ''
    #     Common arguments to pass to the rsync command.
    #   '';
    # };

    jobs = lib.mkOption {
      description = ''
        Synchronization jobs to run.
      '';
      default = { };
      type = types.attrsOf (
        types.submodule {
          options = {
            sources = lib.mkOption {
              type = types.listOf types.str;
              example = [
                "/srv/src1/"
                "/srv/src2/"
              ];
              description = ''
                Source directories.
              '';
            };

            destination = lib.mkOption {
              type = types.str;
              example = "/srv/dst/";
              description = ''
                Destination directory.
              '';
            };

            settings = lib.mkOption {
              type = settingsType;
              default = { };
              example = {
                verbose = true;
              };
              description = ''
                Extra arguments to pass to the rsync command.
              '';
            };

            user = lib.mkOption {
              type = types.str;
              default = "root";
              description = ''
                The name of an existing user account under which the rsync process should run.
              '';
            };

            group = lib.mkOption {
              type = types.str;
              default = "root";
              description = ''
                The name of an existing user group under which the rsync process should run.
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
              type = types.listOf types.str;
              example = [
                "sleep"
              ];
              description = ''
                Run the rsync process with an inhibition lock taken;
                see {manpage}`systemd-inhibit(1)` for a list of possible operations.
              '';
            };
          };
        }
      );
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = lib.all (job: job.sources != [ ]) (lib.attrValues cfg.jobs);
        message = ''
          At least one source directory must be provided to rsync.
        '';
      }
    ];

    systemd = lib.mkMerge (
      lib.mapAttrsToList (
        jobName: job:
        let
          systemdName = "rsync-job-${jobName}";
          description = "Directory syncing via rsync job ${jobName}";
        in
        {
          timers.${systemdName} = {
            wantedBy = [
              "timers.target"
            ];
            inherit description;
            inherit (job) timerConfig;
          };

          services.${systemdName} = {
            inherit description;

            serviceConfig = {
              Type = "oneshot";
              User = job.user;
              Group = job.group;

              NoNewPrivileges = true;
              PrivateDevices = true;
              ProtectSystem = "full";
              ProtectKernelTunables = true;
              ProtectKernelModules = true;
              ProtectControlGroups = true;
              MemoryDenyWriteExecute = true;
              LockPersonality = true;
            };

            script =
              let
                settingsShell = settingsToShell job.settings;
                inhibitString = lib.concatStringsSep ":" job.inhibit;
              in
              ''
                ${
                  lib.optionalString (job.inhibit != [ ]) ''
                    ${lib.getExe' config.systemd.package "systemd-inhibit"} \
                      --mode block \
                      --who ${lib.escapeShellArg description} \
                      --what ${lib.escapeShellArg inhibitString} \
                      --why ${lib.escapeShellArg "Scheduled rsync job ${jobName}"} \
                      -- \
                  ''
                } \
                ${lib.getExe cfg.package} ${settingsShell} -- \
                  ${lib.escapeShellArgs job.sources} \
                  ${lib.escapeShellArg job.destination}
              '';
          };
        }
      ) cfg.jobs
    );
  };

  meta.maintainers = [
    lib.maintainers.lukaswrz
  ];
}
