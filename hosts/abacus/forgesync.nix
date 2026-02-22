{ config, secretsPath, inputs, ... }:
{
  imports = [
    inputs.forgesync.nixosModules.default
  ];

  age.secrets = {
    forgesync-github.file = secretsPath + /forgesync/github.age;
    forgesync-codeberg.file = secretsPath + /forgesync/codeberg.age;
  };

  services.forgesync = {
    enable = true;
    jobs = {
      github = {
        source = "https://hack.moontide.ink/api/v1";
        target = "github";

        settings = {
          remirror = true;
          feature = [
            "issues"
            "pull-requests"
          ];
          on-commit = true;
          mirror-interval = "0h0m0s";
        };

        secretFile = config.age.secrets.forgesync-github.path;

        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
      };

      codeberg = {
        source = "https://hack.moontide.ink/api/v1";
        target = "codeberg";

        settings = {
          remirror = true;
          feature = [
            "issues"
            "pull-requests"
          ];
          on-commit = true;
          mirror-interval = "0h0m0s";
        };

        secretFile = config.age.secrets.forgesync-codeberg.path;

        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
      };
    };
  };
}
