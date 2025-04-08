{
  attrName,
  config,
  lib,
  ...
}: {
  age.secrets = lib.mkSecrets {"restic-${attrName}" = {};};

  services.restic.backups.${attrName} = {
    repository = "sftp:u385962@u385962.your-storagebox.de:/restic/${attrName}";
    initialize = true;
    paths = [
      config.services.vaultwarden.backupDir
      config.services.syncthing.dataDir
      config.services.forgejo.stateDir
      config.services.postgresqlBackup.location
      config.services.postgresqlBackup.location
      # TODO: Add stateDir options for these
      "/var/lib/headscale"
      "/var/lib/navidrome"
    ];
    passwordFile = config.age.secrets."restic-${attrName}".path;
    pruneOpts = ["--keep-daily 7" "--keep-weekly 5" "--keep-monthly 12"];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Persistent = true;
    };
    extraOptions = ["sftp.args='-i /etc/ssh/ssh_host_ed25519_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'"];
  };
}
