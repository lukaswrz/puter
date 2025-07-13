{
  attrName,
  config,
  inputs,
  ...
}:
let
  secretName = "restic-${attrName}";
  secret = config.age.secrets.${secretName};
in
{
  age.secrets.${secretName}.file = inputs.self + /secrets/restic/${attrName}.age;

  services.restic.backups.remote = {
    repository = "sftp:u459482@u459482.your-storagebox.de:/${attrName}";
    initialize = true;
    paths = [
      config.services.vaultwarden.backupDir
      config.services.syncthing.dataDir
      config.services.forgejo.stateDir
      config.services.forgejo.dump.backupDir
      config.services.postgresqlBackup.location
      # config.services.navidrome.settings.Backup.Path
      # TODO: Add stateDir options for these
      "/var/lib/headscale"
      "/var/lib/navidrome"
    ];
    passwordFile = secret.path;
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
    ];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Persistent = true;
    };
    extraOptions = [
      "sftp.args='-i /etc/ssh/ssh_host_ed25519_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'"
    ];
  };
}
