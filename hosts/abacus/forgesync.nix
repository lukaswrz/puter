{ config, inputs, ... }:
{
  imports = [
    inputs.forgesync.nixosModules.default
  ];

  age.secrets.forgesync-github.file = inputs.self + /secrets/forgesync/github.age;

  services.forgesync = {
    enable = true;
    jobs.github = {
      source = "https://hack.helveticanonstandard.net/api/v1";
      target = "github";

      settings = {
        remirror = true;
        feature = [
          "issues"
          "pull-requests"
        ];
        sync-on-push = true;
        mirror-interval = "0h0m0s";
      };

      secretFile = config.age.secrets.forgesync-github.path;

      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };
  };
}
