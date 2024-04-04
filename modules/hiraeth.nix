{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.hiraeth;
  settingsFormat = pkgs.formats.toml {};
in {
  options.services.hiraeth = {
    enable = lib.mkEnableOption "hiraeth";
    package = lib.mkPackageOption pkgs "hiraeth" {};
    settings = lib.mkOption {
      type = settingsFormat.type;
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.hiraeth = {
      description = "Hiraeth File Sharing Service";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        User = config.users.users.hiraeth.name;
        Group = config.users.groups.hiraeth.name;
        StateDirectory = "hiraeth";
        StateDirectoryMode = "0700";
        UMask = "0077";
        WorkingDirectory = "/var/lib/hiraeth";
        ExecStart = "${pkgs.getExe' cfg.package "hiraeth"} run";
        Restart = "always";
        TimeoutSec = 10;
        ReadOnlyPaths = "/etc/hiraeth/hiraeth.toml";
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        ProtectHome = "read-only";
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = ["AF_INET" "AF_INET6"];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };

    users = {
      users.hiraeth = {
        isSystemUser = true;
        group = config.users.groups.hiraeth.name;
      };
      groups.hiraeth = {};
    };

    environment.etc."hiraeth/hiraeth.toml" = {
      source = settingsFormat.generate "hiraeth.toml" cfg.settings;

      mode = "0440";
      user = config.users.users.hiraeth.name;
      group = config.users.users.hiraeth.group;
    };
  };
}
