{
  configName,
  config,
  secretsPath,
  ...
}:
let
  secretName = "restic-${configName}";
  secret = config.age.secrets.${secretName};
in
{
  age.secrets.${secretName}.file = secretsPath + /restic/${configName}.age;

  services.restic.backups.remote = {
    repository = "sftp:u322470-sub3@u322470.your-storagebox.de:restic/${configName}";
    initialize = true;
    paths = [
      "/var/lib/syncthing"
      "/srv/vault"
      "/srv/void"
      config.services.navidrome.settings.Backup.Path
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
