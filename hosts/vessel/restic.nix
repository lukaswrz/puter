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

  services.restic.backups = {
    local = {
      repository = "/srv/backup/void";
      initialize = true;
      paths = [
        "/srv/void"
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
    };

    remote = {
      repository = "sftp:u459482@u459482.your-storagebox.de:/${attrName}";
      initialize = true;
      paths = [
        config.services.syncthing.dataDir
        "/srv/vault"
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
  };
}
