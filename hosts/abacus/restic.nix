{
  configName,
  config,
  secretsPath,
  ...
}:
let
  passwordSecretName = "restic-password-${configName}";
  locationSecretName = "restic-location-${configName}";
in
{
  age.secrets = {
    ${passwordSecretName} = {
      file = secretsPath + /restic/passwords/${configName}.age;
      owner = config.services.restic.backups.remote.user;
    };
    ${locationSecretName} = {
      file = secretsPath + /restic/locations/${configName}.age;
      owner = config.services.restic.backups.remote.user;
    };
  };

  services.restic.backups.remote = {
    repositoryFile = config.age.secrets.${locationSecretName}.path;
    initialize = true;
    paths = [
      config.services.vaultwarden.backupDir
      "/var/lib/syncthing"
      config.services.forgejo.stateDir
      config.services.forgejo.dump.backupDir
      config.services.postgresqlBackup.location
      "/var/lib/headscale"
    ];
    passwordFile = config.age.secrets.${passwordSecretName}.path;
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
