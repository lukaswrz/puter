{
  config,
  pkgs,
  lib,
  ...
}: let
  giteaSecretFile = config.sops.secrets."woodpecker/gitea".path;
  sharedSecretFile = config.sops.secrets."woodpecker/shared".path;

  port = 3030;
  rpcPort = 3031;
in {
  sops.secrets."woodpecker/gitea" = {};
  sops.secrets."woodpecker/shared" = {};

  services.postgresql = {
    enable = true;

    ensureDatabases = ["woodpecker"];

    ensureUsers = [
      {
        name = "woodpecker";
        ensurePermissions = {
          "DATABASE woodpecker" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  services.nginx.virtualHosts."woodpecker.defenestrated.systems" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://localhost:${builtins.toString port}/";
  };

  services = {
    woodpecker-server = {
      enable = true;

      environment = {
        WOODPECKER_HOST = "https://woodpecker.defenestrated.systems";
        WOODPECKER_OPEN = "false";
        WOODPECKER_GITEA = "true";
        WOODPECKER_GITEA_CLIENT = "true";
        WOODPECKER_GITEA_URL = config.services.gitea.settings.server.ROOT_URL;
        WOODPECKER_ADMIN = "lukaswrz";

        WOODPECKER_DATABASE_DRIVER = "postgres";
        WOODPECKER_DATABASE_DATASOURCE = "postgres:///woodpecker?host=/run/postgresql";

        WOODPECKER_SERVER_ADDR = ":${builtins.toString port}";
        WOODPECKER_GRPC_ADDR = ":${builtins.toString rpcPort}";

        WOODPECKER_LOG_LEVEL = "debug";
      };
    };

    woodpecker-agents = {
      agents.exec = {
        enable = true;

        environment = {
          WOODPECKER_SERVER = "localhost:${toString rpcPort}";
          WOODPECKER_MAX_WORKFLOWS = "10";
          WOODPECKER_BACKEND = "local";
          WOODPECKER_FILTER_LABELS = "type=exec";
          WOODPECKER_HEALTHCHECK = "false";

          NIX_REMOTE = "daemon";
          PAGER = "cat";
        };

        environmentFile = [sharedSecretFile];
      };

      agents.docker = {
        enable = true;

        environment = {
          WOODPECKER_SERVER = "localhost:${toString rpcPort}";
          WOODPECKER_MAX_WORKFLOWS = "10";
          WOODPECKER_BACKEND = "docker";
          WOODPECKER_FILTER_LABELS = "type=docker";
          WOODPECKER_HEALTHCHECK = "false";
        };

        environmentFile = [sharedSecretFile];

        extraGroups = ["docker"];
      };
    };
  };

  systemd.services.woodpecker-server = {
    serviceConfig = {
      # Set username for database access
      User = "woodpecker";

      BindPaths = [
        # Allow access to the database path
        "/run/postgresql"
      ];

      # Why is services.woodpecker-server.environmentFile just a single path?
      EnvironmentFile = [giteaSecretFile sharedSecretFile];
    };
  };

  # Adjust exec runner service for Nix
  systemd.services.woodpecker-agent-exec = {
    # Might break deployment
    restartIfChanged = false;

    path = with pkgs; [
      woodpecker-plugin-git
      bash
      coreutils
      git
      git-lfs
      gnutar
      gzip
      nix
    ];

    serviceConfig = {
      # Same option as upstream, without @setuid
      SystemCallFilter = lib.mkForce "~@clock @privileged @cpu-emulation @debug @keyring @module @mount @obsolete @raw-io @reboot @swap";

      BindPaths = [
        "/nix/var/nix/daemon-socket/socket"
        "/run/nscd/socket"
      ];

      BindReadOnlyPaths = [
        "/etc/passwd:/etc/passwd"
        "/etc/group:/etc/group"
        "/etc/nix:/etc/nix"
        "${config.environment.etc."ssh/ssh_known_hosts".source}:/etc/ssh/ssh_known_hosts"
        "/etc/machine-id"
        # Channels are dynamic paths in the nix store, therefore we need to bind mount the whole thing
        "/nix/"
      ];
    };
  };

  virtualisation.docker.enable = true;

  # Adjust Docker runner service for Nix
  systemd.services.woodpecker-agent-docker = {
    after = ["docker.socket"];

    # Might break deployment
    restartIfChanged = false;

    serviceConfig = {
      BindPaths = [
        "/var/run/docker.sock"
      ];
    };
  };
}
